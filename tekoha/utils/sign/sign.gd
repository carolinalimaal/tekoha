class_name Sign
extends StaticBody2D

@export var sign_text: DialogueSettings

@onready var interactable_component: InteractableComponent = $InteractableComponent

func interact() -> void:
	DialogueManager.start_speech(sign_text)
