extends Node2D

@onready var torche_one: StaticBody2D = $Torches/Torche
@onready var torche_two: StaticBody2D = $Torches/Torche2
@onready var torche_three: StaticBody2D = $Torches/Torche3
@onready var root: StaticBody2D = $Roots
@onready var animated_sprite: AnimatedSprite2D = $Roots/AnimatedSprite2D

var torches_off: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	torche_one.torch_turnned_off.connect(_on_torch_turned_off)
	torche_two.torch_turnned_off.connect(_on_torch_turned_off)
	torche_three.torch_turnned_off.connect(_on_torch_turned_off)

func _on_torch_turned_off(_torch_id: int):
	torches_off+=1
	print(torches_off)
	if torches_off == 3:
		animated_sprite.play("default")
		root.set_collision_layer_value(9, false)
