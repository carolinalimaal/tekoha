extends Level

@onready var roll_mecanic: Node2D = $RollMecanic
@onready var npc_cecilia: NPC = $NpcCecila
@onready var first_cecilia_spawn: Marker2D = $FirstCeciliaSpawnPoint
@onready var second_cecilia_spawn: Marker2D = $SecondCeciliaSpawnPoint
@onready var room7_door: Door = $Room7Door

func _ready() -> void:
	if GameManager.current_save.game_state < GameManager.GameState.AFTER_FIRST_ENEMY:
		roll_mecanic.disable()
	else:
		roll_mecanic.enable()
		room7_door.monitoring = false
	_update_cecilia()
	GlobalSignals.game_state_changed.connect(_on_game_state_changed)

func _exit_tree() -> void:
	GlobalSignals.game_state_changed.disconnect(_on_game_state_changed)

func _update_cecilia() -> void:
	var state = GameManager.current_save.game_state
	if state <= GameManager.GameState.TRAINING_COMPLETE:
		npc_cecilia.global_position = first_cecilia_spawn.global_position
		npc_cecilia.npc_dialogue = npc_cecilia.dialogues_list[0]
	elif state >= GameManager.GameState.AFTER_FIRST_ENEMY:
		npc_cecilia.global_position = second_cecilia_spawn.global_position
		npc_cecilia.npc_dialogue = npc_cecilia.dialogues_list[1]

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state >= GameManager.GameState.AFTER_FIRST_ENEMY:
		roll_mecanic.enable()
	else:
		roll_mecanic.disable()
	_update_cecilia()
	if new_state == GameManager.GameState.SECOND_MEETING_CECILIA:
		_go_to_room7()

func _go_to_room7() -> void:
	room7_door.monitoring = true
	GlobalSignals.animation_midpoint_reached.connect(room7_door.on_animation_midpoint_reached, CONNECT_ONE_SHOT)
	get_tree().paused = true
	GlobalSignals.emit_signal("door_entered")
