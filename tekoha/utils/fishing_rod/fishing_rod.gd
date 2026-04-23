class_name FishingRod
extends StaticBody2D

signal fishing_rod_interated

var has_interacted: bool

@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void:
	# TODO: Adicionar verificação do estado atual do jogo
	if GameManager.current_save.game_state > GameManager.GameState.BEFORE_FISHING:
		has_interacted = true

func interact() -> void:
	if !has_interacted:
		fishing_rod_interated.emit()
