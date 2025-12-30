class_name PickupItem
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var item_data: ItemData

func _ready() -> void:
	if item_data:
		sprite.texture = item_data.icon
		collision.shape = item_data.collision_shape
