class_name Muiraquita
extends Area2D

@export var id: int

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Verificar se esse controle de spawnar ou nao ficara no muiraquita ou no level
	if GameManager.current_save.collected_muiraquitas.has(id):
		modulate = Color(1,1,1,0.3)
	
	animation_player.play("default")

func collect() -> void:
	# Bloquear registrar duas vezes o mesmo muiraquita
	if !GameManager.current_save.collected_muiraquitas.has(id):
		# TODO: substituir por sfx específico do muiraquitã quando disponível
		if GameManager.current_save.known_items.has("muiraquita"):
			AudioManager.create_2d_audio_at_location(position, SoundEffect.SOUND_EFFECT_TYPE.MUIRAQUITA)
		GlobalSignals.new_muiraquita_found.emit(id)
		GlobalSignals.hud_info.emit("Muiraquitã coletado!")
		modulate = Color(1,1,1,0.3)
