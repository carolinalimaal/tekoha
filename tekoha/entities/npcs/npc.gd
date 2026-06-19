class_name NPC extends CharacterBody2D

@export var animated_sprite: AnimatedSprite2D
@export var npc_dialogue: DialogueSettings

@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_timeline_started)
	DialogueManager.dialogue_ended.connect(_on_timeline_ended)

func _exit_tree() -> void:
	if DialogueManager.dialogue_started.is_connected(_on_timeline_started):
		DialogueManager.dialogue_started.disconnect(_on_timeline_started)
	if DialogueManager.dialogue_ended.is_connected(_on_timeline_ended):
		DialogueManager.dialogue_ended.disconnect(_on_timeline_ended)

func interact() -> void:
	DialogueManager.start_speech(npc_dialogue)
	interactable_component.disable_interaction()

func _on_timeline_started() -> void:
	pass

func _on_timeline_ended() -> void:
	interactable_component.enable_interaction()
