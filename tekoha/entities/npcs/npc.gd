class_name NPC extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var npc_dialogue: DialogueSettings

var is_interacting: bool = false

@onready var interact_area: Area2D = $InteractArea
@onready var interact_ui: CanvasLayer = $InteractUI

func _ready() -> void:
	interact_area.body_entered.connect(_on_player_entered)
	interact_area.body_exited.connect(_on_player_exited)
	DialogueControl.dialogue_started.connect(_on_timeline_started)
	DialogueControl.dialogue_ended.connect(_on_timeline_ended)
	
	interact_ui.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact"):
		if !is_interacting and interact_ui.visible:
			interact()

func interact() -> void:
	DialogueControl.start_speech(npc_dialogue)
	interact_ui.hide()

func _on_player_entered(body: Node2D):
	if body is Player:
		interact_ui.show()

func _on_player_exited(body: Node2D):
	if body is Player:
		interact_ui.hide()

func _on_timeline_started() -> void:
	is_interacting = true

func _on_timeline_ended() -> void:
	is_interacting = false
	interact_ui.show()
