extends Node2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $Attack/HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $Attack/HurtboxComponent

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar

var state_machine: StateMachine



func _ready() -> void:
	progress_bar.set_max(health_component.max_health)
	health_component.health_changed.connect(on_health_changed)
	
	state_machine = $StateMachine
	state_machine.init(self)
	hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	hitbox_component.hitbox_collision.set_deferred("disabled", true)
	
	health_component.died.connect(_on_boss_died)
	hitbox_component.attack_received.connect(_on_boss_attack_received)
	
func _process(delta: float) -> void:
	pass

func _on_boss_died():
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.ARRAIA_DIE)
	
func _on_boss_attack_received(attack_data: AttackData):
	if state_machine.current_state.name in ["Death", "Stun"]:
		return
	health_component.take_damage(attack_data)

func on_health_changed():
	progress_bar.set_value(health_component.current_health)
