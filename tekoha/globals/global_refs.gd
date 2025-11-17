extends Node

var game_manager
var input_manager: InputManager
var audio_manager


var inventory: Inventory
var player: Player

func _ready() -> void:
	inventory = Inventory.new()
