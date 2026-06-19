class_name SavePoint
extends StaticBody2D

@export var hammock_texture: Texture
@export var hammock_collision: Shape2D

var detecting_player: bool

@onready var sprite: Sprite2D = $Sprite
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void:	
	sprite.texture = hammock_texture
	collision.shape = hammock_collision

func interact() -> void:
	UIManager.is_interact_ui_open = true
	interactable_component.disable_interaction()
	GlobalRefs.confirmation_popup.setup("Deseja salvar o jogo?", null, true, "Salvar")
	UIManager.open_menu("confirmation")
	_connect_signals()

func _on_save_confirmed() -> void:
	SaveManager.save_game(GameManager.current_save)
	# Talvez esse som va para a Label na HUD para notificacoes
	AudioManager.create_2d_audio_at_location(position, SoundEffect.SOUND_EFFECT_TYPE.SAVE)
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
