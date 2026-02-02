class_name Heart extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func update_sprite(value: int):
	animated_sprite_2d.animation = str(clampi(value, 0, 4))
	animated_sprite_2d.frame = 0
