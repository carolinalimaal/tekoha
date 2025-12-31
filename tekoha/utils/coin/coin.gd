class_name Coin
extends Area2D

@export var value: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("default")

func collect() -> void:
	GlobalSignals.coin_collected.emit(value)
	# TODO: adicionar som de coletar moeda
	queue_free()
