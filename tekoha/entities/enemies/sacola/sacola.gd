class_name Sacola
extends Enemy

signal puzzle_activator()

@export_category("Range")
@export var chase_range: int = 200
@export var attack_range: int = 50

var chase_range_sqr: int
var attack_range_sqr: int

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
	attack_range_sqr = attack_range * attack_range
	
	state_machine.init(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_enemy_died():
	# Transicionar para DEATH
	var parent = get_parent()
	if parent.name == "MecanicActivators":
		puzzle_activator.emit()
	state_machine.current_state.transition_to("Death")

func _on_enemy_attack_received(attack_data: AttackData):
	# Nao sofre dano se estiver em DEATH ou STUN
	if state_machine.current_state.name in ["Death", "Stun"]:
		return
	# Sofrer o dano 
	health_component.take_damage(attack_data)
	# Verifica novamente se nao foi para o estado de morte
	if state_machine.current_state.name != "Death":
		# Passar os dados do ataque para o stun_state e transicionar para STUN
		var stun_state : StunState = state_machine.states.get("stun")
		stun_state.receive_attack_data(attack_data)
		state_machine.current_state.transition_to("Stun")
