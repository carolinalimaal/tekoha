class_name SaveData
extends Resource

@export var game_state: GameManager.GameState
@export var player_health: int
@export var wallet: int
@export var known_items: Dictionary
@export var collected_muiraquitas: Dictionary
@export var opened_chests: Dictionary
@export var inventory_slots: Array[ItemSlot]
@export var player_position: Vector2
@export var camera_pos: Vector2
@export var current_level_path: String

func _init() -> void:
	game_state = GameManager.GameState.NEW_GAME
	player_health = 12
	wallet = 0
	known_items = {}
	collected_muiraquitas = {}
	opened_chests = {}
	player_position = Vector2.ZERO
	camera_pos = Vector2.ZERO
	current_level_path = 'res://levels/room_1/casa.tscn'
	
	for i in range(6):
		inventory_slots.append(ItemSlot.new(i))
