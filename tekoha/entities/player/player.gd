class_name Player
extends CharacterBody2D

signal player_dead()
signal health_changed()

const SPEED : float = 150.0 #150.0
const ROLL_SPEED : float = 170.0

var move_direction : Vector2
var mouse_direction : Vector2
var facing_direction : Vector2 = Vector2.RIGHT
var attack_direction : Vector2
var roll_direction : Vector2

var can_move : bool = true
var can_attack_1 : bool = false
var can_attack_2 : bool = false
var attack_2_locked: bool = true
var can_roll : bool = true

var roll_cooldown : float = 1.0

var anim_transition : int = 0

@export_range(0.0, 1.0, 0.01) var low_health_threshold: float = 0.25
var _is_low_health: bool = false

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: StateMachine = $StateMachine
@onready var point_light_2d: PointLight2D = $PointLight2D

func _init() -> void:
	GlobalRefs.player = self

func _ready() -> void:
	# Conectar sinais
	health_component.died.connect(_on_player_died)
	hitbox_component.attack_received.connect(_on_player_attack_received)
	health_changed.connect(_on_health_changed)
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	GlobalSignals.game_state_changed.connect(_on_game_state_changed)
	# Iniciar state_machine
	state_machine.init(self)
	# Adicionar ao grupo "player"
	self.add_to_group("player")
	$PointLight2D.hide()
	
	# Carregar dados do save
	update_stats_from_save()

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
			if state_machine.current_state.name in ["Attack2", "Roll", "Stun"]:
				return
			if can_attack_1 and !can_attack_2:
				state_machine.current_state.transition_to("Attack1")
			elif can_attack_2 and !attack_2_locked:
				state_machine.current_state.transition_to("attack2")
			
		elif InputManager.get_action_pressed("roll") and can_roll:
			# Bloquear rolagem se estiver em ATTACK1 ou ATTACK2
			if state_machine.current_state.name in ["Attack1", "Attack2"]:
				return
			state_machine.current_state.transition_to("Roll")

func get_direction() -> Vector2:
	if !can_move:
		return Vector2.ZERO
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

func _on_health_changed() -> void:
	var health_ratio = float(health_component.current_health) / float(health_component.max_health)
	if health_component.current_health > 0 and health_ratio <= low_health_threshold:
		if !_is_low_health:
			_is_low_health = true
			AudioManager.start_looping_audio(SoundEffect.SOUND_EFFECT_TYPE.LOW_HEALTH)
	elif _is_low_health:
		_is_low_health = false
		AudioManager.stop_looping_audio(SoundEffect.SOUND_EFFECT_TYPE.LOW_HEALTH)

func _exit_tree() -> void:
	if _is_low_health:
		_is_low_health = false
		AudioManager.stop_looping_audio(SoundEffect.SOUND_EFFECT_TYPE.LOW_HEALTH)
	if DialogueManager.dialogue_started.is_connected(_on_dialogue_started):
		DialogueManager.dialogue_started.disconnect(_on_dialogue_started)
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	if GlobalSignals.game_state_changed.is_connected(_on_game_state_changed):
		GlobalSignals.game_state_changed.disconnect(_on_game_state_changed)

func _on_dialogue_started() -> void:
	if _is_low_health:
		AudioManager.stop_looping_audio(SoundEffect.SOUND_EFFECT_TYPE.LOW_HEALTH)

func _on_dialogue_ended() -> void:
	if _is_low_health:
		AudioManager.start_looping_audio(SoundEffect.SOUND_EFFECT_TYPE.LOW_HEALTH)

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state == GameManager.GameState.POS_BOSSFIGHT:
		_is_low_health = false

func _on_player_attack_received(attack_data: AttackData):
	# Nao sofre dano se estiver em DEATH ou STUN, nem durante dialogos/cutscenes
	if state_machine.current_state.name in ["Death", "Stun"]:
		return
	if DialogueManager.is_showing:
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

func update_stats_from_save() -> void:
	if GameManager.current_save:
		# Atualizar a vida
		health_component.current_health = GameManager.current_save.player_health
		health_changed.emit()
		
		# Atualizar flags de habilidades
		var state = GameManager.current_save.game_state
		if state >= GameManager.GameState.TRAINING_COMPLETE:
			can_attack_1 = true
			attack_2_locked = false
			can_roll = true
		else:
			can_attack_1 = false
			attack_2_locked = true
			can_roll = false

func play_sfx_walk() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.CURUPIRA_WALK)

func play_sfx_attack_1() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.CURUPIRA_ATTACK_1)

func play_sfx_attack_2() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.CURUPIRA_ATTACK_2)

func play_sfx_roll() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.CURUPIRA_ROLL)

func play_sfx_take_damage() -> void:
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.CURUPIRA_STUN)


func turn_light_on_or_off(light: bool):
	if light:
		$PointLight2D.show()
	else:
		$PointLight2D.hide()

func enable_attack_2():
	can_attack_2 = true
	
func disable_attack_2():
	can_attack_2 = false
