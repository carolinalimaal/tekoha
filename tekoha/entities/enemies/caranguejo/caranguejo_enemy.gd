class_name CaranguejoEnemy
extends Enemy

signal puzzle_activator()

@export_category("Range")
@export var align_threshold: float = 12.0
@export var attack_range: int = 40

@export_category("Shaders")
@export var take_damage_effect: Shader
@export var death_effect: Shader

var attack_range_sqr: int
var is_dead: bool = false

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

func _ready() -> void:
	sprite_2d.material = sprite_2d.material.duplicate()
	state_machine = $StateMachine
	attack_range_sqr = attack_range * attack_range
	health_component.died.connect(_on_enemy_died)
	hitbox_component.attack_received.connect(_on_enemy_attack_received)
	state_machine.init(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func apply_damage():
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blink_intensity, 1.0, 0.0, 0.5)

func set_shader_blink_intensity(value: float) -> void:
	sprite_2d.material.set_shader_parameter("blink_intensity", value)

func die() -> void:
	var death_material = ShaderMaterial.new()
	death_material.shader = death_effect
	sprite_2d.material = death_material
	var tween = get_tree().create_tween()
	tween.tween_method(set_death_progress, 0.0, 1.0, 1.2)
	tween.tween_callback(queue_free)

func set_death_progress(value: float) -> void:
	sprite_2d.material.set_shader_parameter("progress", value)

func _on_enemy_died():
	is_dead = true
	var parent = get_parent()
	if parent.name == "MecanicActivators":
		puzzle_activator.emit()
	state_machine.set_process(false)
	set_physics_process(false)
	hitbox_component.hitbox_collision.set_deferred("disabled", true)
	hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	die()

func _on_enemy_attack_received(attack_data: AttackData):
	if is_dead or state_machine.current_state.name in ["Stun"]:
		return
	health_component.take_damage(attack_data)
	if not is_dead:
		apply_damage()
		var stun_state = state_machine.states.get("stun")
		stun_state.receive_attack_data(attack_data)
		state_machine.current_state.transition_to("Stun")
