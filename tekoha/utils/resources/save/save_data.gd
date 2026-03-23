class_name SaveData
extends Resource

@export var player_health: int
@export var wallet: int
@export var known_items: Dictionary
@export var collected_muiraquitas: Dictionary
@export var opened_chests: Dictionary
@export var inventory_slots: Array[ItemSlot]

func _init() -> void:
	player_health = 12
	wallet = 0
	known_items = {}
	collected_muiraquitas = {}
	opened_chests = {}
	
	for i in range(6):
		inventory_slots.append(ItemSlot.new(i))
