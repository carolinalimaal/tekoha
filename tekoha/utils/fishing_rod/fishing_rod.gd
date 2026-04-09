class_name FishingRod
extends StaticBody2D

signal fishing_rod_interated

var has_interacted: bool
var is_showing: bool

@onready var interaction_ui: CanvasLayer = $InteractionUI
@onready var interact_area: Area2D = $InteractArea

func _ready() -> void:
	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)
	
	# TODO: Adicionar verificação do estado atual do jogo
	if GameManager.current_save.game_state > GameManager.GameState.BEFORE_FISHING:
		has_interacted = true
	
	is_showing = false
	
	interaction_ui.hide()

# Lógica de apertar o interact input dentro da área do baú
func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact"):
		if is_showing and !has_interacted:
			fishing_rod_interated.emit()
			interaction_ui.hide()

func _on_body_entered(body: Node2D) -> void:
	if (body is Player or body.is_in_group("player")) and !has_interacted:
		is_showing = true
		interaction_ui.show()

func _on_body_exited(body: Node2D) -> void:
	if body is Player or body.is_in_group("player"):
		is_showing = false
		interaction_ui.hide()
