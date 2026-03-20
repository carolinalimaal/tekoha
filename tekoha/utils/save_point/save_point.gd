class_name SavePoint
extends StaticBody2D

@export var hammock_texture: Texture

var detecting_player: bool

@onready var interaction_area: Area2D = $InteractionArea
@onready var sprite: Sprite2D = $Sprite
@onready var interaction_ui: CanvasLayer = $InteractionUI
@onready var interaction_container: MarginContainer = $InteractionUI/InteractionContainer
@onready var confirmation_popup: Panel = $InteractionUI/ConfirmationPopup
@onready var confirm_button: Button = $InteractionUI/ConfirmationPopup/Bg/MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button: Button = $InteractionUI/ConfirmationPopup/Bg/MarginContainer/VBoxContainer/HBoxContainer/CancelButton

func _ready() -> void:
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	cancel_button.pressed.connect(_on_cancel_button_pressed)
	
	sprite.texture = hammock_texture
	
	interaction_ui.visible = false
	interaction_container.visible = true
	confirmation_popup.visible = false

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact") and detecting_player:
		_interact()

func _interact() -> void:
	confirmation_popup.visible = true
	confirm_button.grab_focus()

func _on_body_entered(body: Node2D) -> void:
	if body is Player or body.is_in_group("player"):
		detecting_player = true
		interaction_ui.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player or body.is_in_group("player"):
		detecting_player = false
		interaction_ui.visible = false

func _on_confirm_button_pressed() -> void:
	SaveManager.save_game(GameManager.current_save)
	confirmation_popup.visible = false

func _on_cancel_button_pressed() -> void:
	confirmation_popup.visible = false
