class_name NPC extends CharacterBody2D

@export var animated_sprite: AnimatedSprite2D
@export var npc_dialogue: DialogueSettings

var is_interacting: bool = false

@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_timeline_started)
	DialogueManager.dialogue_ended.connect(_on_timeline_ended)

func interact() -> void:
	DialogueManager.start_speech(npc_dialogue)
	interactable_component.disable_interaction()

func _on_timeline_started() -> void:
	is_interacting = true

func _on_timeline_ended() -> void:
	is_interacting = false
	interactable_component.enable_interaction()
