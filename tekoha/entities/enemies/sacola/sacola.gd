class_name Sacola
extends Enemy

@export_category("Range")
@export var chase_range: int = 200
@export var circling_range: int = 100
@export var attack_range: int = 50
@export var retreat_range: int = 25

var chase_range_sqr: int
var circling_range_sqr: int
var attack_range_sqr: int
var retreat_range_sqr: int

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

func _ready() -> void:
	animation_tree = $AnimationTree
	state_machine = $StateMachine
	nav_agent = $NavAgent
	
	# Conectar sinais
	health_component.died.connect(_on_enemy_died)
	hitbox_component.attack_received.connect(_on_enemy_attack_received)
	
	chase_range_sqr = chase_range * chase_range
	circling_range_sqr = circling_range * circling_range
	attack_range_sqr = attack_range * attack_range
	retreat_range_sqr = retreat_range * retreat_range
	
	state_machine.init(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func die():
	# TODO: ver possivel dependencia com health_component
	await get_tree().create_timer(.2).timeout
	queue_free()

func _on_enemy_died():
	# Transicionar para DEATH
	state_machine.current_state.transition_to("Death")

func _on_enemy_attack_received(attack_data: AttackData):
	# Sofrer o dano 
	health_component.take_damage(attack_data)
	# Passar os dados do ataque para o stun_state e transicionar para STUN
	var stun_state : StunState = state_machine.states.get("stun")
	if state_machine.current_state.name not in ["Stun", "Death"]:
		stun_state.receive_attack_data(attack_data)
		state_machine.current_state.transition_to("Stun")
