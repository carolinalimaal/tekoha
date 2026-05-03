class_name SecretArea
extends Area2D

@export var roof_layer: CanvasItem
@export var fade_aplha: float = 0.3
@export var fade_time: float = 0.3

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_fade_roof(fade_aplha)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_fade_roof(1.0)

func _fade_roof(target_alpha: float) -> void:
	if roof_layer:
		var tween = create_tween()
		tween.tween_property(roof_layer, "modulate:a", target_alpha, fade_time)
