class_name Coin
extends Area2D

@export var value: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("default")

func collect() -> void:
	GlobalSignals.coin_collected.emit(value)
	queue_free()
