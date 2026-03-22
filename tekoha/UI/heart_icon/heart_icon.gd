class_name Heart
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func update_sprite(value: int):
	animation_player.play(str(clampi(value, 0, 4)))
