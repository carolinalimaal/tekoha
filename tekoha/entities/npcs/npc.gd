extends CharacterBody2D

@export var sprite: AnimatedSprite2D

var is_interacting: bool = false

@onready var interact_area: Area2D = $InteractArea
@onready var interact_ui: CanvasLayer = $InteractUI

func _ready() -> void:
	interact_area.body_entered.connect(_on_player_entered)
	interact_area.body_exited.connect(_on_player_exited)
	
	interact_ui.visible = false

func _unhandled_input(_event: InputEvent) -> void:
	if GlobalRefs.input_manager.get_action_pressed("interact"):
		if !is_interacting and interact_ui.visible:
			interact()

func interact() -> void:
	is_interacting = true
	print("NPC começa a falar.")
	await get_tree().create_timer(2.0).timeout
	stop_interaction()

func stop_interaction() -> void:
	is_interacting = false
	print("NPC terminou de falar.")

func _on_player_entered(body: Node2D):
	if body is Player:
		interact_ui.visible = true

func _on_player_exited(body: Node2D):
	if body is Player:
		interact_ui.visible = false
