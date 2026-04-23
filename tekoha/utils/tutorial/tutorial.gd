extends Node2D

enum TutorialState {
	NOT_INITIATED,
	ATTACK_1,
	ATTACK_2,
	ROLL,
	FINISHED
}
var current_state: TutorialState = TutorialState.NOT_INITIATED

var index: int = 0
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

func _ready() -> void:
	practice_dummy_2.damage_received.connect(_on_dummy_damage_received)
	practice_dummy.hide()
	roll_area.hide()
	transition_layer.hide()
	global_position = Vector2(-357.0, 645.0)

func interact() -> void:
	if current_state == TutorialState.NOT_INITIATED:
		start_tutorial()

func _on_dummy_damage_received(attack_data: AttackData) -> void:
	if current_state != TutorialState.NOT_INITIATED:
		match current_state:
			TutorialState.ATTACK_1:
				if attack_data.damage_value == 4:
					print("Ataque 1 realizado")
					current_state = TutorialState.ATTACK_2
					GlobalRefs.player.can_attack_2 = true
					index += 1
					DialogueManager.start_speech(tutorial_instructions[index])
		
			TutorialState.ATTACK_2:
				if attack_data.damage_value == 6:
					print("Ataque 2 realizado")
					start_roll_tutorial()

func _on_roll_area_body_entered(body: Node2D) -> void:
	if body is Player and current_state == TutorialState.ROLL:
		if body.state_machine.current_state.name in ["Roll"]:
			print("Roll realizado")
			end_tutorial()
		else:
			print("Ops! Você deve entrar com dash nessa área!")
			DialogueManager.start_speech(tutorial_instructions[index])

func _on_cutscene_ended() -> void:
	if current_state == TutorialState.ROLL and !practice_dummy.visible:
		dummy_appearence_anim()
		roll_area.show()
	
	if index > 0:
		player_reposition_respawn()

func start_tutorial() -> void:
	interactable_comp.disable_interaction()
	set_limits_layer(true)
	zoom_in_camera()
	print("Tutorial iniciado")
	current_state = TutorialState.ATTACK_1
	DialogueManager.dialogue_ended.connect(_on_cutscene_ended)
	GlobalRefs.player.can_attack_1 = true
	DialogueManager.start_speech(tutorial_instructions[index])

func start_roll_tutorial() -> void:
	current_state = TutorialState.ROLL
	GlobalRefs.player.can_roll = true
	index += 1
	DialogueManager.start_speech(tutorial_instructions[index])
	index += 1

func end_tutorial() -> void:
	current_state = TutorialState.FINISHED
	DialogueManager.dialogue_ended.disconnect(_on_cutscene_ended)
	GameManager.current_save.game_state = GameManager.GameState.TRAINING_COMPLETE
	print("Tutorial finalizado")
	set_limits_layer(false)
	zoom_out_camera()

func set_limits_layer(condition: bool) -> void:
	tutorial_limit_1.set_collision_layer_value(8, condition)
	tutorial_limit_2.set_collision_layer_value(8, condition)

func zoom_in_camera() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(get_node("../../../PlayerCamera"), "zoom", Vector2(2,2), 1)
	
func zoom_out_camera() -> void:
	await get_tree().create_timer(1).timeout
	var tween: Tween = create_tween()
	tween.tween_property(get_node("../../../PlayerCamera"), "zoom", Vector2(1,1), 1)

func dummy_appearence_anim() -> void:
	GlobalRefs.player.can_move = false
	transition_layer.show()
	transition_rect.modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 1, 1.0)
	tween.tween_callback(func(): practice_dummy.show())
	tween.tween_property(transition_rect, "modulate:a", 0, 1.0)
	await tween.finished
	transition_layer.hide()
	GlobalRefs.player.can_move = true

func player_reposition_respawn() -> void:
	GlobalRefs.player.position = player_reposition.global_position
