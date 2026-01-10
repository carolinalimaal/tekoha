class_name Heart extends Panel

@onready var sprite_2d: Sprite2D = $Sprite2D

func update_sprite(value: int):
	sprite_2d.frame = clampi(value, 0, 4)
