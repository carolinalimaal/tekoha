class_name PathBlock
extends Area2D

@export var path_block_message: DialogueSettings
@export var push_direction: Vector2 = Vector2.DOWN # Direção (ex: (0, 1) para baixo, (-1, 0) para esquerda)
@export var push_distance: float = 64.0 # Distância que o jogador será empurrado em pixels
@export var push_duration: float = 0.3 # Tempo que o empurrão vai durar em segundos

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		DialogueManager.start_speech(path_block_message)
		_push_back_player(body)

func _push_back_player(player: Player) -> void:
	var direction = push_direction.normalized()
	var target_position = player.global_position + (direction * push_distance)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(player, "global_position", target_position, push_duration)
