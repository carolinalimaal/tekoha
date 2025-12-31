class_name Coin
extends Area2D

@export var value: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("default")

func collect() -> void:
	# TODO: adicionar som de coletar moeda
	GameManager.add_coin(value)
	queue_free()
