class_name Player
extends CharacterBody2D

signal player_dead()

const SPEED : float = 100.0
const ROLL_SPEED : float = 120.0

var move_direction : Vector2
var mouse_direction : Vector2
var facing_direction : Vector2 = Vector2.RIGHT
var attack_direction : Vector2
var roll_direction : Vector2

var can_roll : bool = true

var roll_cooldown : float = 2.0

var anim_transition : int = 0

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	GlobalRefs.player = self
	# Conectar sinais
	health_component.died.connect(_on_player_died)
	hitbox_component.attack_received.connect(_on_player_attack_received)
	# Iniciar state_machine
	state_machine.init(self)
	# Adicionar ao grupo "player"
	self.add_to_group("player")

func _physics_process(_delta: float) -> void:
	move_and_slide()

# Gerenciar os inputs para as acoes
func _unhandled_input(_event: InputEvent) -> void:
	if GlobalRefs.input_manager.get_action_pressed("attack"):
		if state_machine.current_state.name != "AttackEnd":
			state_machine.current_state.transition_to("attack1")
		else:
			state_machine.current_state.transition_to("attack2")
	elif GlobalRefs.input_manager.get_action_pressed("roll") and can_roll:
		state_machine.current_state.transition_to("roll")

func get_direction() -> Vector2:
	return GlobalRefs.input_manager.get_movement_vector().normalized()

func get_aim_direction() -> Vector2:
	return GlobalRefs.input_manager.get_aim_direction().normalized()

func die():
	# TODO: ver possivel dependencia com health_component
	await get_tree().create_timer(.3).timeout
	queue_free()
	player_dead.emit()

func _on_player_died():
	# Transicionar para DEATH
	state_machine.current_state.transition_to("death")

func _on_player_attack_received(attack_data: AttackData):
	# Sofrer o dano 
	health_component.take_damage(attack_data)
	# Passar os dados do ataque para o stun_state e transicionar para STUN
	var stun_state : StunState = state_machine.states.get("stun")
	if state_machine.current_state.name not in ["stun", "death"]:
		stun_state.receive_attack_data(attack_data)
		state_machine.current_state.transition_to("stun")
