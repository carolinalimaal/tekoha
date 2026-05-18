extends Level

@export var room_2_music: AudioStream

@onready var room_4_door: Door = $Room4Door
@onready var path_block: PathBlock = $PathBlock

func _ready() -> void:
	AudioManager.play_background_sound(room_2_music)
	
	if GameManager.current_save.game_state <= GameManager.GameState.BEFORE_FISHING:
		room_4_door.monitoring = false 
		path_block.monitoring = true
	else:
		room_4_door.monitoring = true 
		path_block.monitoring = false
