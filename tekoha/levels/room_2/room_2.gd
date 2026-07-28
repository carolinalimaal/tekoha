extends Level

@export var bg_music: MusicTrack
@export var path_block_messages: Array[DialogueSettings]

@onready var room_4_door: Door = $Room4Door
@onready var room_3_door: Door = $Room3Door
@onready var path_block: PathBlock = $PathBlock
@onready var path_block_2: PathBlock = $PathBlock2

func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
	
	if GameManager.current_save.game_state <= GameManager.GameState.BEFORE_FISHING:
		_lock_room_door(room_3_door, path_block_2, false)
		_lock_room_door(room_4_door, path_block, true, 0)
	elif GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_3:
		_lock_room_door(room_3_door, path_block_2, true, 1)
		_lock_room_door(room_4_door, path_block, false)
	elif GameManager.current_save.game_state == GameManager.GameState.PRE_BOSSFIGHT:
		_lock_room_door(room_3_door, path_block_2, false)
		_lock_room_door(room_4_door, path_block, true, 2)
	else:
		_lock_room_door(room_3_door, path_block_2, false)
		_lock_room_door(room_4_door, path_block, false)

func _lock_room_door(door: Door, path: PathBlock, lock: bool, i: int = -1) -> void:
	if lock:
		door.set_deferred("monitoring", false)
		path.set_deferred("monitoring", true)
		path.path_block_message = path_block_messages[i]
	else:
		door.set_deferred("monitoring", true)
		path.set_deferred("monitoring", false)
		path.path_block_message = path_block_messages[i]
