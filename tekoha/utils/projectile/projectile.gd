class_name Projectile
extends Node2D

@export var speed : int
@export var animation_tree: AnimationTree
@export var hurtbox_component: HurtboxComponent
@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true
	
	visible_on_screen_notifier.screen_exited.connect(_on_visible_on_screen_notifier_screen_exited)

func _process(delta: float) -> void:
	animation_tree.set("parameters/blend_position", direction)
	position += direction * speed * delta

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
