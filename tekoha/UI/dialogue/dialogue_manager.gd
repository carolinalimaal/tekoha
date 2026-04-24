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
var active_text_label: RichTextLabel

@onready var solid_background: ColorRect = $SolidBackground
@onready var cutscene_background: TextureRect = $CutsceneBackground
@onready var dialogue_box: PanelContainer = $DialogueBox
@onready var speech_text_dialogue: RichTextLabel = $DialogueBox/MarginContainer/SpeechTextDialogue
@onready var cutscene_box: PanelContainer = $CutsceneBox
@onready var speech_text_cutscene: RichTextLabel = $CutsceneBox/MarginContainer/SpeechTextCutscene

func _ready() -> void:
	solid_background.hide()
	cutscene_background.hide()
	dialogue_box.hide()
	cutscene_box.hide()
	is_showing = false

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("ui_accept") and is_showing:
		_next_sentence()

func start_speech(dialogue_data: DialogueSettings) -> void:
	if !is_showing:
		dialogue_box.show()
		UIManager.is_interact_ui_open = true
		is_showing = true
		current_dialogue = dialogue_data.dialogues
		index = 0
		
		if GlobalRefs.player:
			GlobalRefs.player.can_move = false
			#if GlobalRefs.player.state_machine != null:
				#GlobalRefs.player.state_machine.current_state.transition_to("Idle")
		
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
	
	_set_background_image(current, is_cutscene)
	
	active_text_label.text = text_to_show
	active_text_label.visible_characters = 0
	
	if type_tween and type_tween.is_running():
		type_tween.kill()
	
	type_tween = create_tween()
	var duration = text_to_show.length() * typing_speed
	type_tween.tween_property(active_text_label, "visible_characters", text_to_show.length(), duration)

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
	UIManager.is_interact_ui_open = false
	is_showing = false
	current_dialogue = []
	
	if solid_background.visible and cutscene_background.visible:
		var fade_tween = create_tween()
		fade_tween.tween_property(cutscene_background, "modulate:a", 0.0, 0.5)
		fade_tween.tween_property(solid_background, "modulate:a", 0.0, 0.5)
		
		await fade_tween.finished
		
		solid_background.hide()
		cutscene_background.hide()
		
		solid_background.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
		cutscene_background.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
		
	if GlobalRefs.player:
		GlobalRefs.player.can_move = true
	
	dialogue_ended.emit()

func _set_background_image(current: DialogueLine, is_cutscene: bool) -> void:
	if is_cutscene:
		dialogue_box.hide()
		cutscene_box.show()
		solid_background.show()
		
		if cutscene_background.texture != current.background_image:
			cutscene_background.texture = current.background_image
			cutscene_background.show()
			
			# Animacao do background
			cutscene_background.modulate.a = 0.0
			var bg_tween = create_tween()
			bg_tween.set_trans(Tween.TRANS_SINE)
			bg_tween.tween_property(cutscene_background, "modulate:a", 1.0, 1.0)
			
			active_text_label = speech_text_cutscene
	else:
		dialogue_box.show()
		cutscene_box.hide()
		solid_background.hide()
		
		active_text_label = speech_text_dialogue

func _set_actor_name(current: DialogueLine) -> String:
	if current.actor_name:
		return current.actor_name + ": "
	else:
		return ""
