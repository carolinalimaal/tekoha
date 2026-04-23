class_name Player
extends CharacterBody2D

signal player_dead()
signal health_changed()

const SPEED : float = 450.0 #250.0
const ROLL_SPEED : float = 120.0

var move_direction : Vector2
var mouse_direction : Vector2
var facing_direction : Vector2 = Vector2.RIGHT
var attack_direction : Vector2
var roll_direction : Vector2

var can_move : bool = true
var can_attack_1 : bool = false
var can_attack_2 : bool = false
var can_roll : bool = true

var roll_cooldown : float = 1.0

var anim_transition : int = 0

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: StateMachine = $StateMachine

func _init() -> void:
	GlobalRefs.player = self

func _ready() -> void:
	# Conectar sinais
	health_component.died.connect(_on_player_died)
	hitbox_component.attack_received.connect(_on_player_attack_received)
	# Iniciar state_machine
	state_machine.init(self)
	# Adicionar ao grupo "player"
	self.add_to_group("player")
	
	# Carregar dados do save
	if GameManager.current_save:
		health_component.current_health = GameManager.current_save.player_health
		health_changed.emit()

func _physics_process(_delta: float) -> void:
	move_and_slide()

# Gerenciar os inputs para as acoes
func _unhandled_input(_event: InputEvent) -> void:
	# Bloquear input se estiver em STUN ou DEATH
	if state_machine.current_state.name in ["Death", "Stun"]:
		return
	
	if can_move:
		if InputManager.get_action_pressed("attack"):
			# Bloquear ataques se ja estiver em ATTACK1 ou ATTACK2 ou ROLL
			if state_machine.current_state.name in ["Attack1", "Attack2", "Roll"]:
				return
			if state_machine.current_state.name != "AttackEnd" and can_attack_1:
				state_machine.current_state.transition_to("Attack1")
			elif state_machine.current_state.name == "AttackEnd" and can_attack_2:
				state_machine.current_state.transition_to("attack2")
			
		elif InputManager.get_action_pressed("roll") and can_roll:
			# Bloquear rolagem se estiver em ATTACK1, ATTACK_END ou ATTACK2
			if state_machine.current_state.name in ["Attack1", "AttackEnd", "Attack2"]:
				return
			state_machine.current_state.transition_to("Roll")

func get_direction() -> Vector2:
	return InputManager.get_movement_vector().normalized()

func get_aim_direction() -> Vector2:
	return InputManager.get_aim_direction().normalized()

func die():
	# TODO: ver possivel dependencia com health_component
	await get_tree().create_timer(.3).timeout
	queue_free()
	player_dead.emit()

func _on_player_died():
	# Transicionar para DEATH
	state_machine.current_state.transition_to("Death")

func _on_player_attack_received(attack_data: AttackData):
	# Nao sofre dano se estiver em DEATH ou STUN
	if state_machine.current_state.name in ["Death", "Stun"]:
		return
		
	# Sofrer o dano 
	health_component.take_damage(attack_data)
	health_changed.emit()
	
	# Verifica novamente se nao foi para o estado de morte
	if state_machine.current_state.name != "Death":
		# Passar os dados do ataque para o stun_state e transicionar para STUN
		var stun_state : StunState = state_machine.states.get("stun")
		stun_state.receive_attack_data(attack_data)
		state_machine.current_state.transition_to("Stun")

func heal(amount: int):
	health_component.heal(amount)
	health_changed.emit()

func play_sfx_walk() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.CURUPIRA_WALK)

func play_sfx_attack_1() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.CURUPIRA_ATTACK_1)

func play_sfx_attack_2() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.CURUPIRA_ATTACK_2)
