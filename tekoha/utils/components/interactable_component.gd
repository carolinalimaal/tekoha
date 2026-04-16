class_name InteractableComponent
extends Area2D

@export var interact_label: String
@export var collision_shape: CollisionShape2D
@export var marker: Marker2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		InteractionManager.register_interactable(get_parent(), interact_label, marker)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		InteractionManager.unregister_interactable(get_parent())

func disable_interaction() -> void:
	monitoring = false
	InteractionManager.unregister_interactable(get_parent())

func enable_interaction() -> void:
	monitoring = true
	for body in get_overlapping_bodies():
		if body is Player:
			InteractionManager.register_interactable(get_parent(), interact_label, marker)
