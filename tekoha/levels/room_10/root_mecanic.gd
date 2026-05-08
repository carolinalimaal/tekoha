extends Node2D

@onready var torche_one: Torch = $Torches/Torche
@onready var torche_two: Torch = $Torches/Torche2
@onready var torche_three: Torch = $Torches/Torche3
@onready var root: Root = $Root
@onready var root_two: Root = $Root2
@onready var root_three: Root = $Root3
@onready var root_four: Root = $Root4
@onready var root_five: Root = $Root5
@onready var root_six: Root = $Root6

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
		root.root_remove()
		root_two.root_remove()
		root_three.root_remove()
		root_four.root_remove()
		root_five.root_remove()
		root_six.root_remove()
