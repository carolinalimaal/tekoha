class_name Muiraquita
extends Area2D

@export var id: int

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Verificar se esse controle de spawnar ou nao ficara no muiraquita ou no level
	if GameManager.muiraquitas_collected.has(id):
		queue_free()
	
	animation_player.play("default")

func collect() -> void:
	# Bloquear registrar duas vezes o mesmo muiraquita
	if !GameManager.muiraquitas_collected.has(id):
		GlobalSignals.new_muiraquita_found.emit(id)
		modulate = Color(1,1,1,0.3)
