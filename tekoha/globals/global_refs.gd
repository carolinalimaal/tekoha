extends Node


var inventory: Inventory
var player: Player

func _ready() -> void:
	inventory = Inventory.new()
