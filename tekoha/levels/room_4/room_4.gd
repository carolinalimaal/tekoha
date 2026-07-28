extends Level

@export var bg_music: MusicTrack

@onready var path_block: PathBlock = $PathBlock
@onready var room_5_door: Door = $Room5Door

func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
	
	if GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_3:
		path_block.set_deferred("monitoring", true)
		room_5_door.set_deferred("monitoring", false)
		
		GlobalRefs.game_nightfall_filter.show()
		GlobalRefs.player.turn_light_on_or_off(true)
		GlobalRefs.player.point_light_2d.energy = 0.4
	else:
		path_block.set_deferred("monitoring", false)
		room_5_door.set_deferred("monitoring", true)
