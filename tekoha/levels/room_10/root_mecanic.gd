class_name RootMecanic extends Node2D

signal shake_camera()

#@onready var torche_one: Torch = $Torches/Torche
#@onready var torche_two: Torch = $Torches/Torche2
#@onready var torche_three: Torch = $Torches/Torche3
#@onready var root: Root = $Root
#@onready var root_two: Root = $Root2
#@onready var root_three: Root = $Root3
#@onready var root_four: Root = $Root4
#@onready var root_five: Root = $Root5
#@onready var root_six: Root = $Root6
@onready var mecanic_activators: Node2D = $MecanicActivators
@onready var roots: Node2D = $Roots

@export var meta_activations: int
var current_activations: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#torche_one.torch_turnned_off.connect(_on_torch_turned_off)
	#torche_two.torch_turnned_off.connect(_on_torch_turned_off)
	#torche_three.torch_turnned_off.connect(_on_torch_turned_off)
	for activator in mecanic_activators.get_children():
		activator.torch_turnned_off.connect(_on_torch_turned_off)

func _on_torch_turned_off(_torch_id: int):
	current_activations+=1
	shake_camera.emit()
	print(current_activations)
	if current_activations == meta_activations:
		for root in roots.get_children():
			root.root_remove()
