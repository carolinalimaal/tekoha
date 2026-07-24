class_name Root extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var flip_sprite: bool = false

func _ready() -> void:
	animated_sprite.flip_h = flip_sprite

func root_remove():
	animated_sprite.play("default")
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.ROOT_SHRINK)
	set_collision_layer_value(9,false)
