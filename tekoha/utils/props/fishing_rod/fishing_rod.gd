class_name FishingRod
extends StaticBody2D

signal fishing_rod_interated

var has_interacted: bool

@onready var interactable_component: InteractableComponent = $InteractableComponent

func interact() -> void:
	if !has_interacted:
		fishing_rod_interated.emit()

func disable_fishing_rod_interaction() -> void:
	has_interacted = true
	if interactable_component:
		interactable_component.disable_interaction()

func enable_fishing_rod_interaction() -> void:
	has_interacted = false
	if interactable_component:
		interactable_component.enable_interaction()
