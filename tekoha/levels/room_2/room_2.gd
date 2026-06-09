extends Level

@export var room_2_music: AudioStream

@onready var room_4_door: Door = $Room4Door
@onready var room_3_door: Door = $Room3Door
@onready var path_block: PathBlock = $PathBlock
@onready var path_block_2: PathBlock = $PathBlock2

func _ready() -> void:
	AudioManager.play_background_sound(room_2_music)
	
	if GameManager.current_save.game_state <= GameManager.GameState.BEFORE_FISHING:
		_lock_room_4_door(true)
		_lock_room_3_door(false)
	elif GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_3:
		_lock_room_4_door(false)
		_lock_room_3_door(true)
	else:
		_lock_room_4_door(false)
		_lock_room_3_door(false)

func _lock_room_4_door(lock: bool) -> void:
	if lock:
		room_4_door.set_deferred("monitoring", false)
		path_block.set_deferred("monitoring", true)
	else:
		room_4_door.set_deferred("monitoring", true)
		path_block.set_deferred("monitoring", false)

func _lock_room_3_door(lock: bool) -> void:
	if lock:
		room_3_door.set_deferred("monitoring", false)
		path_block_2.set_deferred("monitoring", true)
	else:
		room_3_door.set_deferred("monitoring", true)
		path_block_2.set_deferred("monitoring", false)
