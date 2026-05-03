class_name Pote extends StaticBody2D

@export var sprite_frames: SpriteFrames

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/HitboxCollision

@onready var collision: CollisionShape2D = $Collision

func _ready() -> void:
	animated_sprite_2d.sprite_frames = sprite_frames
	animated_sprite_2d.frame = 0
	y_sort_enabled = true
	z_index = 0
	
	hitbox_component.attack_received.connect(_on_pot_attack_received)
	health_component.died.connect(_on_pot_destroyed)
	
func _on_pot_attack_received(attack_data: AttackData):
	health_component.take_damage(attack_data)
	animated_sprite_2d.play("default")

func _on_pot_destroyed():
	hitbox_component.set_deferred("monitoring", false)
	hitbox_collision.set_deferred("disabled", true)
	collision.set_deferred("disabled", true)
	y_sort_enabled = false
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.BREAKING_POT)
