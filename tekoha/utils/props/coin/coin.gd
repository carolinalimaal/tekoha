class_name Coin
extends Area2D

@export var value: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("default")

func collect() -> void:
	if GameManager.current_save.known_items.has("coin"):
		AudioManager.create_2d_audio_at_location(position, SoundEffect.SOUND_EFFECT_TYPE.COIN)
	GlobalSignals.coin_collected.emit(value)
	queue_free()
