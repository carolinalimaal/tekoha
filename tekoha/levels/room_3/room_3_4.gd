extends State

@export var npc_iara_scene: PackedScene

const NPC_IARA_POSITION := Vector2(1106, 704)

@onready var room_34_door: Door = $"../../Room34Door"

var npc_iara_instance: Node2D

func _enter() -> void:
	if npc_iara_scene and !npc_iara_instance:
		npc_iara_instance = npc_iara_scene.instantiate()
		npc_iara_instance.position = NPC_IARA_POSITION
		owner_node.add_child(npc_iara_instance)
	GlobalSignals.game_state_changed.connect(_on_game_state_changed)

func _exit() -> void:
	if GlobalSignals.game_state_changed.is_connected(_on_game_state_changed):
		GlobalSignals.game_state_changed.disconnect(_on_game_state_changed)
	if npc_iara_instance:
		npc_iara_instance.queue_free()
		npc_iara_instance = null

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state == GameManager.GameState.BOSSFIGHT:
		_go_to_boss_room()

func _go_to_boss_room() -> void:
	room_34_door.monitoring = true
	if !GlobalSignals.animation_midpoint_reached.is_connected(room_34_door.on_animation_midpoint_reached):
		GlobalSignals.animation_midpoint_reached.connect(room_34_door.on_animation_midpoint_reached, CONNECT_ONE_SHOT)
	get_tree().paused = true
	GlobalSignals.emit_signal("door_entered")
