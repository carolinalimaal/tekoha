extends CanvasLayer

signal dialogue_started
signal dialogue_ended

enum Idiom {
	PT, 
	EN
}

@export var language: Idiom = Idiom.PT
@export var typing_speed: float = 0.05

var is_showing: bool
var current_dialogue: Array[DialogueLine]
var index: int
var type_tween: Tween
var bg_tween: Tween
var active_text_label: RichTextLabel
var skip_cooldown_timer: float = 0.0
var _last_typed_character_count: int = 0

const SKIP_COOLDOWN: float = 0.15

@onready var solid_background: ColorRect = $SolidBackground
@onready var cutscene_background: TextureRect = $CutsceneBackground
@onready var dialogue_box: PanelContainer = $DialogueBox
@onready var speech_text_dialogue: RichTextLabel = $DialogueBox/MarginContainer/SpeechTextDialogue
@onready var cutscene_box: PanelContainer = $CutsceneBox
@onready var speech_text_cutscene: RichTextLabel = $CutsceneBox/MarginContainer/SpeechTextCutscene
@onready var navigation_legend: NavigationLegend = $NavigationLegend

func _ready() -> void:
	solid_background.hide()
	cutscene_background.hide()
	dialogue_box.hide()
	cutscene_box.hide()
	navigation_legend.hide()
	is_showing = false
	InputManager.input_source_changed.connect(_on_input_source_changed)

func _process(delta: float) -> void:
	if skip_cooldown_timer > 0:
		skip_cooldown_timer -= delta

func _input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("skip_dialogue") and is_showing and skip_cooldown_timer <= 0:
		get_viewport().set_input_as_handled()
		skip_cooldown_timer = SKIP_COOLDOWN
		_next_sentence()

func start_speech(dialogue_data: DialogueSettings) -> void:
	if !is_showing:
		UIManager.is_interact_ui_open = true
		is_showing = true
		current_dialogue = dialogue_data.dialogues
		index = 0
		
		if GlobalRefs.player:
			GlobalRefs.player.can_move = false
		
		_show_sentence()
		dialogue_started.emit()

func _show_sentence() -> void:
	var current = current_dialogue[index]
	var is_cutscene = current.background_image != null
	
	var text_to_show = _set_actor_name(current)
	match language:
		Idiom.PT:
			text_to_show += current.text_pt
		Idiom.EN:
			text_to_show += current.text_en
	
	text_to_show = InputManager.icon_mapper.parse_input_text(text_to_show, 36)
	
	_set_background_image(current, is_cutscene)
	
	active_text_label.text = text_to_show
	active_text_label.visible_characters = 0
	_last_typed_character_count = 0

	if type_tween and type_tween.is_running():
		type_tween.kill()

	type_tween = create_tween()
	var duration = text_to_show.length() * typing_speed
	type_tween.tween_method(_on_type_progress, 0, text_to_show.length(), duration)

func _on_type_progress(visible_characters: int) -> void:
	active_text_label.visible_characters = visible_characters

	if visible_characters <= _last_typed_character_count:
		return
	_last_typed_character_count = visible_characters

	var revealed_text := active_text_label.get_parsed_text()
	if visible_characters > revealed_text.length():
		return

	var revealed_char := revealed_text[visible_characters - 1]
	if !revealed_char.strip_edges().is_empty():
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.TYPING)

func _next_sentence() -> void:
	if !is_showing:
		return
	
	if type_tween and type_tween.is_running():
		type_tween.kill()
		active_text_label.visible_characters = -1
		return
	
	if index < current_dialogue.size() - 1:
		index += 1
		_show_sentence()
	else:
		_end_speech()

func _end_speech() -> void:
	dialogue_box.hide()
	cutscene_box.hide()
	navigation_legend.hide()
	UIManager.is_interact_ui_open = false
	is_showing = false
	current_dialogue = []
	index = 0
	
	if solid_background.visible and cutscene_background.visible:
		if bg_tween and bg_tween.is_running():
			bg_tween.kill()

		var fade_tween = create_tween()
		fade_tween.tween_property(cutscene_background, "modulate:a", 0.0, 0.5)
		fade_tween.tween_property(solid_background, "modulate:a", 0.0, 0.5)
		
		await fade_tween.finished
		
		solid_background.hide()
		cutscene_background.hide()
		cutscene_background.texture = null
		
		solid_background.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
		cutscene_background.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
		
	if GlobalRefs.player:
		GlobalRefs.player.can_move = true
	
	dialogue_ended.emit()

func _set_background_image(current: DialogueLine, is_cutscene: bool) -> void:
	if is_cutscene:
		dialogue_box.hide()
		cutscene_box.visible = !current.hide_text_box
		solid_background.show()
		navigation_legend.show()

		active_text_label = speech_text_cutscene

		if cutscene_background.texture != current.background_image:
			cutscene_background.texture = current.background_image
			cutscene_background.show()

			if bg_tween and bg_tween.is_running():
				bg_tween.kill()

			# Animacao do background
			cutscene_background.modulate.a = 0.0
			bg_tween = create_tween()
			bg_tween.set_trans(Tween.TRANS_SINE)
			bg_tween.tween_property(cutscene_background, "modulate:a", 1.0, 1.0)
	else:
		dialogue_box.visible = !current.hide_text_box
		cutscene_box.hide()
		solid_background.hide()
		navigation_legend.show()

		active_text_label = speech_text_dialogue

func _set_actor_name(current: DialogueLine) -> String:
	if current.actor_name:
		return current.actor_name + ": "
	else:
		return ""

func force_close() -> void:
	is_showing = false
	current_dialogue = []
	index = 0
	dialogue_box.hide()
	cutscene_box.hide()
	solid_background.hide()
	cutscene_background.hide()
	navigation_legend.hide()
	cutscene_background.texture = null
	UIManager.is_interact_ui_open = false
	if type_tween and type_tween.is_running():
		type_tween.kill()
	if bg_tween and bg_tween.is_running():
		bg_tween.kill()

func _on_input_source_changed(_source: InputManager.InputSource) -> void:
	if is_showing:
		var current = current_dialogue[index]
		var text_to_show = _set_actor_name(current)
		match language:
			Idiom.PT:
				text_to_show += current.text_pt
			Idiom.EN:
				text_to_show += current.text_en
		text_to_show = InputManager.icon_mapper.parse_input_text(text_to_show, 36)
		active_text_label.text = text_to_show
		active_text_label.visible_characters = -1
