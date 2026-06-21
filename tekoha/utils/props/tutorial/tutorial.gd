extends Node2D

signal tutorial_finished

enum TutorialState {
	NOT_INITIATED,
	ATTACK_1,
	ATTACK_2,
	ROLL,
	FINISHED
}

const DIALOG_ATTACK_1 = 0
const DIALOG_ATTACK_2 = 1
const DIALOG_ROLL = 2
const DIALOG_ROLL_FAIL = 3

# Valores de dano esperados
const DMG_EXPECTED_ATTACK_1 = 4
const DMG_EXPECTED_ATTACK_2 = 6

# Tempos de espera
const DELAY_UI_FEEDBACK = 1.2
const DELAY_ROLL_CHECK = 0.5
const DELAY_CAMERA_ZOOM = 1.0

var current_state: TutorialState = TutorialState.NOT_INITIATED

@export var tutorial_instructions: Array[DialogueSettings]

@onready var practice_dummy: StaticBody2D = $PracticeDummy
@onready var practice_dummy_2: StaticBody2D = $PracticeDummy2
@onready var interactable_comp: InteractableComponent = $InteractableComponent
@onready var player_reposition: Marker2D = $PlayerReposition
@onready var roll_area: Area2D = $RollArea
@onready var tutorial_limit_1: StaticBody2D = $Limits/TutorialLimit
@onready var tutorial_limit_2: StaticBody2D = $Limits/TutorialLimit2
@onready var transition_layer: CanvasLayer = $TransitionLayer
@onready var transition_rect: ColorRect = $TransitionLayer/TransitionCont/TransitionRect
@onready var tutorial_ui: CanvasLayer = $TutorialUI

func _ready() -> void:
	practice_dummy_2.damage_received.connect(_on_dummy_damage_received)
	_setup_initial_state()

func _setup_initial_state() -> void:
	_set_second_dummy_visible(false)
	roll_area.hide()
	transition_layer.hide()
	global_position = Vector2(-357.0, 645.0)

func interact() -> void:
	if current_state == TutorialState.NOT_INITIATED:
		_start_tutorial()

# MÁQUINA DE ESTADOS
func _change_state(new_state: TutorialState) -> void:
	current_state = new_state
	
	match current_state:
		TutorialState.ATTACK_1:
			GlobalRefs.player.can_attack_1 = true
			_play_dialogue(DIALOG_ATTACK_1)
			
		TutorialState.ATTACK_2:
			tutorial_ui.mark_attack_1_done()
			await _wait(DELAY_UI_FEEDBACK)
			GlobalRefs.player.attack_2_locked = false
			_play_dialogue(DIALOG_ATTACK_2)
			
		TutorialState.ROLL:
			tutorial_ui.mark_attack_2_done()
			await _wait(DELAY_UI_FEEDBACK)
			GlobalRefs.player.can_roll = true
			_play_dialogue(DIALOG_ROLL)
			
		TutorialState.FINISHED:
			tutorial_ui.mark_roll_done()
			await _wait(DELAY_UI_FEEDBACK)
			_end_tutorial()

# SINAIS / INTERAÇÕES
func _on_dummy_damage_received(attack_data: AttackData) -> void:
	if current_state == TutorialState.ATTACK_1 and attack_data.damage_value == DMG_EXPECTED_ATTACK_1:
		_change_state(TutorialState.ATTACK_2)
	elif current_state == TutorialState.ATTACK_2 and attack_data.damage_value == DMG_EXPECTED_ATTACK_2:
		_change_state(TutorialState.ROLL)

func _on_roll_area_body_entered(body: Node2D) -> void:
	if !(body is Player) or current_state != TutorialState.ROLL:
		return
		
	if body.state_machine.current_state.name == "Roll":
		await _wait(DELAY_ROLL_CHECK)
		_change_state(TutorialState.FINISHED)
	else:
		_play_dialogue(DIALOG_ROLL_FAIL)

func _on_cutscene_started() -> void:
	tutorial_ui.hide_ui()

func _on_cutscene_ended() -> void:
	if current_state == TutorialState.ROLL and !practice_dummy.visible:
		player_reposition_respawn()
		dummy_appearance_anim()
		roll_area.show()
	elif current_state != TutorialState.ATTACK_1:
		player_reposition_respawn()

	if current_state != TutorialState.FINISHED:
		tutorial_ui.show_ui()

# FLUXO DO TUTORIAL
func _start_tutorial() -> void:
	interactable_comp.disable_interaction()
	set_limits_layer(true)
	_set_camera_zoom(Vector2(2, 2))
	
	DialogueManager.dialogue_ended.connect(_on_cutscene_ended)
	DialogueManager.dialogue_started.connect(_on_cutscene_started)
	
	_change_state(TutorialState.ATTACK_1)

func _end_tutorial() -> void:
	DialogueManager.dialogue_ended.disconnect(_on_cutscene_ended)
	DialogueManager.dialogue_started.disconnect(_on_cutscene_started)
	
	GameManager.set_game_state(GameManager.GameState.TRAINING_COMPLETE)
	set_limits_layer(false)
	_set_camera_zoom(Vector2(1.5, 1.5), DELAY_CAMERA_ZOOM)
	tutorial_ui.hide_ui()
	tutorial_finished.emit()

# FUNÇÕES UTILITÁRIAS E VISUAIS
func _play_dialogue(dialog_index: int) -> void:
	if dialog_index < tutorial_instructions.size():
		DialogueManager.start_speech(tutorial_instructions[dialog_index])

func _wait(seconds: float) -> Signal:
	return get_tree().create_timer(seconds).timeout

func set_limits_layer(condition: bool) -> void:
	tutorial_limit_1.set_collision_layer_value(8, condition)
	tutorial_limit_2.set_collision_layer_value(8, condition)

func _set_camera_zoom(target: Vector2, pre_delay: float = 0.0) -> void:
	if pre_delay > 0.0:
		await _wait(pre_delay)
	var tween: Tween = create_tween()
	tween.tween_property(GlobalRefs.player_camera, "zoom", target, DELAY_CAMERA_ZOOM)

func dummy_appearance_anim() -> void:
	GlobalRefs.player.can_move = false
	transition_layer.show()
	transition_rect.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 1.0, 1.0)
	tutorial_ui.hide_ui()
	tween.tween_callback(_set_second_dummy_visible.bind(true))
	tween.tween_property(transition_rect, "modulate:a", 0.0, 1.0)

	await tween.finished
	tutorial_ui.show_ui()
	transition_layer.hide()
	GlobalRefs.player.can_move = true

func player_reposition_respawn() -> void:
	GlobalRefs.player.global_position = player_reposition.global_position

func _set_second_dummy_visible(is_visible: bool) -> void:
	practice_dummy.visible = is_visible
	practice_dummy.collision_shape.set_deferred("disabled", !is_visible)

func disable_tutorial_interaction() -> void:
	interactable_comp.disable_interaction()
