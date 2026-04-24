class_name ConfirmationPopup 
extends Control

signal confirmed
signal cancelled

@onready var margin_container: MarginContainer = $Background/CenterContainer/PanelContainer/MarginContainer

@onready var icon: TextureRect = $Background/CenterContainer/PanelContainer/MarginContainer/HBoxContainer/Icon
@onready var message_label: RichTextLabel = $Background/CenterContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/MessageLabel

@onready var button_container: HBoxContainer = $Background/CenterContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/ButtonContainer
@onready var confirm_button: DefaultButton = $Background/CenterContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/ButtonContainer/ConfirmButton
@onready var cancel_button: DefaultButton = $Background/CenterContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/ButtonContainer/CancelButton

func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	
	hide()

# Função principal que configura o que aparece
func setup(message: String, _icon: Texture2D = null, show_buttons: bool = true, _left_button_text: String = "Confirmar", _right_button_text: String = "Cancelar") -> void:
	confirm_button.text = _left_button_text
	cancel_button.text = _right_button_text
	
	message_label.text = message
	
	if _icon:
		icon.texture = _icon
		icon.show()
	else:
		icon.hide()
	
	button_container.visible = show_buttons

func _on_confirm_pressed() -> void:
	confirmed.emit()

func _on_cancel_pressed() -> void:
	cancelled.emit()

func grab_initial_focus() -> void:
	if button_container.visible:
		confirm_button.grab_focus()

func cancel_action() -> void:
	_on_cancel_pressed()
