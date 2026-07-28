extends Node2D

@export var take_damage_effect: Shader
@export var blink_duration: float = 0.8

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $Attack/HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $Attack/HurtboxComponent

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $CanvasLayer/VBoxContainer/ProgressBar
@onready var body: Sprite2D = $Body
@onready var tail: Sprite2D = $Attack/Tail

var state_machine: StateMachine



func _ready() -> void:
	progress_bar.set_max(health_component.max_health)
	health_component.health_changed.connect(on_health_changed)

	body.material = body.material.duplicate()
	tail.material = body.material
	if take_damage_effect:
		body.material.shader = take_damage_effect

	state_machine = $StateMachine
	state_machine.init(self)
	hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	hitbox_component.hitbox_collision.set_deferred("disabled", true)

	health_component.died.connect(_on_boss_died)
	hitbox_component.attack_received.connect(_on_boss_attack_received)

func _process(_delta: float) -> void:
	pass

func _on_boss_died():
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.ARRAIA_DIE)

func _on_boss_attack_received(attack_data: AttackData):
	if state_machine.current_state.name in ["Death", "Stun"]:
		return
	health_component.take_damage(attack_data)
	apply_damage()
	GlobalRefs.player_camera.apply_shake()
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.ARRAIA_STUN)

func apply_damage() -> void:
	var tween := get_tree().create_tween()
	tween.tween_method(set_shader_blink_intensity, 1.0, 0.0, blink_duration)

func set_shader_blink_intensity(value: float) -> void:
	body.material.set_shader_parameter("blink_intensity", value)

func on_health_changed():
	progress_bar.set_value(health_component.current_health)
