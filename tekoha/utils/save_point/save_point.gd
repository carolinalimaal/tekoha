class_name SavePoint
extends StaticBody2D

@export var hammock_texture: Texture

var detecting_player: bool

@onready var sprite: Sprite2D = $Sprite
@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void:	
	sprite.texture = hammock_texture
	

func interact() -> void:
	UIManager.is_interact_ui_open = true
	interactable_component.disable_interaction()
	GlobalRefs.confirmation_popup.setup("Deseja salvar o jogo?", null, true, "Salvar")
	UIManager.open_menu("confirmation")
	_connect_signals()

func _on_save_confirmed() -> void:
	SaveManager.save_game(GameManager.current_save)
	UIManager.is_interact_ui_open = false
	interactable_component.enable_interaction()
	UIManager.close_top_menu()
	_disconnect_signals()

func _on_save_cancelled() -> void:
	UIManager.is_interact_ui_open = false
	interactable_component.enable_interaction()
	UIManager.close_top_menu()
	_disconnect_signals()

func _connect_signals() -> void:
	if !GlobalRefs.confirmation_popup.confirmed.is_connected(_on_save_confirmed):
		GlobalRefs.confirmation_popup.confirmed.connect(_on_save_confirmed)
	if !GlobalRefs.confirmation_popup.cancelled.is_connected(_on_save_cancelled):
		GlobalRefs.confirmation_popup.cancelled.connect(_on_save_cancelled)

func _disconnect_signals() -> void:
	if GlobalRefs.confirmation_popup.confirmed.is_connected(_on_save_confirmed):
		GlobalRefs.confirmation_popup.confirmed.disconnect(_on_save_confirmed)
	if GlobalRefs.confirmation_popup.cancelled.is_connected(_on_save_cancelled):
		GlobalRefs.confirmation_popup.cancelled.disconnect(_on_save_cancelled)
