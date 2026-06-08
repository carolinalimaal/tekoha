class_name Projectile
extends Area2D

@export var speed : int
@export var animation_tree: AnimationTree
@export var hurtbox_component: HurtboxComponent
@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true
	# Adicionar ao grupo "projectile"
	self.add_to_group("projectile")
	area_entered.connect(_on_area_entered)
	visible_on_screen_notifier.screen_exited.connect(_on_visible_on_screen_notifier_screen_exited)

func _process(delta: float) -> void:
	animation_tree.set("parameters/blend_position", direction)
	position += direction * speed * delta

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.get_collision_mask_value(128):
		print("bateu em parede")
