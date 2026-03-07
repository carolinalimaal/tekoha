class_name SaveData
extends Resource

@export var player_health: int
@export var wallet: int
@export var collected_muiraquitas: Dictionary
@export var opened_chests: Dictionary
@export var inventory_slots: Array[ItemSlot]

func _init() -> void:
	player_health = 12
	wallet = 0
	collected_muiraquitas = {}
	opened_chests = {}
	
	for i in range(6):
		inventory_slots.append(ItemSlot.new(i))
