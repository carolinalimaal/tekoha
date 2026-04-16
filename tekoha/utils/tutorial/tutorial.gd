extends Node2D

enum TutorialState {
	NOT_INITIATED,
	ATTACK_1,
	ATTACK_2,
	ROLL,
	FINISHED
}
var current_state: TutorialState = TutorialState.NOT_INITIATED

var can_interact: bool = false

var index: int = 0
@export var tutorial_instructions: Array[DialogueSettings]

@onready var practice_dummy: StaticBody2D = $PracticeDummy
@onready var practice_dummy_2: StaticBody2D = $PracticeDummy2
@onready var interaction_area: Area2D = $InteractionArea
@onready var roll_area: Area2D = $RollArea
@onready var tutorial_limit_1: StaticBody2D = $Limits/TutorialLimit
@onready var tutorial_limit_2: StaticBody2D = $Limits/TutorialLimit2
@onready var finish_timer: Timer = $FinishTimer
@onready var interaction_ui: CanvasLayer = $InteractionUI
@onready var int_container: MarginContainer = $InteractionUI/InteractionContainer
@onready var transition_cont: MarginContainer = $InteractionUI/TransitionCont
@onready var transition_rect: ColorRect = $InteractionUI/TransitionCont/TransitionRect
@onready var int_ui_label: Label = $InteractionUI/InteractionContainer/ColorRect/Label


func _ready() -> void:
	practice_dummy_2.damage_received.connect(_on_dummy_damage_received)
	practice_dummy.hide()
	roll_area.hide()
	transition_cont.hide()
	global_position = Vector2(-357.0, 645.0)

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact"):
		if current_state == TutorialState.NOT_INITIATED and can_interact:
			start_tutorial()
			can_interact = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player and current_state == TutorialState.NOT_INITIATED:
		interaction_ui.show()
		can_interact = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is Player and current_state == TutorialState.NOT_INITIATED:
		interaction_ui.hide()
		can_interact = false

func _on_dummy_damage_received(attack_data: AttackData):
	if current_state != TutorialState.NOT_INITIATED:
		match current_state:
			TutorialState.ATTACK_1:
				if attack_data.damage_value == 4:
					print("Ataque 1 realizado")
					current_state = TutorialState.ATTACK_2
					GlobalRefs.player.can_attack_2 = true
					index += 1
					DialogueControl.start_speech(tutorial_instructions[index])
					update_ui()
		
			TutorialState.ATTACK_2:
				if attack_data.damage_value == 6:
					print("Ataque 2 realizado")
					start_roll_tutorial()

func _on_finish_timer_timeout() -> void:
	zoom_out_camera()
	interaction_ui.hide()

func _on_roll_area_body_entered(body: Node2D) -> void:
	if body is Player and current_state == TutorialState.ROLL:
		if body.state_machine.current_state.name in ["Roll"]:
			print("Roll realizado")
			end_tutorial()
		else:
			print("Ops! Você deve entrar com dash nessa área!")

func _on_cutscene_ended():
	dummy_appearence_anim()
	DialogueControl.dialogue_ended.disconnect(_on_cutscene_ended)

func start_tutorial() -> void:
	interaction_area.hide()
	set_limits_layer(true)
	zoom_in_camera()
	print("Tutorial iniciado")
	current_state = TutorialState.ATTACK_1
	GlobalRefs.player.can_attack_1 = true
	update_ui()
	DialogueControl.start_speech(tutorial_instructions[index])

func start_roll_tutorial():
	DialogueControl.dialogue_ended.connect(_on_cutscene_ended)
	current_state = TutorialState.ROLL
	GlobalRefs.player.can_roll = true
	index += 1
	DialogueControl.start_speech(tutorial_instructions[index])
	roll_area.show()
	update_ui()

func end_tutorial():
	current_state = TutorialState.FINISHED
	print("Tutorial finalizado")
	set_limits_layer(false)
	update_ui()
	

func set_limits_layer(condition: bool):
	tutorial_limit_1.set_collision_layer_value(8, condition)
	tutorial_limit_2.set_collision_layer_value(8, condition)

func update_ui():
	match current_state:
		TutorialState.ATTACK_1:
			interaction_container_adjustments(967, 313)
			int_ui_label.text = "Clique no botão esquerdo para atacar"
		
		TutorialState.ATTACK_2:
			interaction_container_adjustments(750, 530)
			int_ui_label.text = "Clique no botão esquerdo duas vezes para realizar o ataque duplo"
		
		TutorialState.ROLL:
			interaction_container_adjustments(915, 365)
			int_ui_label.text = "Clique no botão direito para realizar o Dash"
		
		TutorialState.FINISHED:
			interaction_container_adjustments(1107, 173)
			int_ui_label.text = "Tutorial finalizado!"
			finish_timer.start()

func interaction_container_adjustments(pos: int, size: int):
	int_container.position.x = pos
	int_container.size.x = size

func zoom_in_camera():
	var tween: Tween = create_tween()
	tween.tween_property(get_node("../../../PlayerCamera"), "zoom", Vector2(2,2), 1)
	
func zoom_out_camera():
	var tween: Tween = create_tween()
	tween.tween_property(get_node("../../../PlayerCamera"), "zoom", Vector2(1,1), 1)

func dummy_appearence_anim():
	GlobalRefs.player.can_move = false
	transition_cont.show()
	transition_rect.modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 1, 1.0)
	tween.tween_callback(func(): practice_dummy.show())
	tween.tween_property(transition_rect, "modulate:a", 0, 1.0)
	await tween.finished
	transition_cont.hide()
	GlobalRefs.player.can_move = true
