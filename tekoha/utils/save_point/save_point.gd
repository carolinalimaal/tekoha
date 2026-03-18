class_name SavePoint
extends Area2D

@onready var interaction_ui: CanvasLayer = $InteractionUI

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	interaction_ui.visible = false

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact") and interaction_ui.visible:
		SaveManager.save_game(GameManager.current_save)

func _on_body_entered(body: Node2D) -> void:
	if body is Player or body.is_in_group("player"):
		interaction_ui.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player or body.is_in_group("player"):
		interaction_ui.visible = false
