extends Level

@export var bg_music: MusicTrack
#@export var motor_loop_duration: float = 2.0

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
		
		#_play_boat_going_away()
	else:
		path_block.set_deferred("monitoring", false)
		room_5_door.set_deferred("monitoring", true)
		

#func _play_boat_going_away() -> void:
	#AudioManager.start_looping_audio_for_duration(SoundEffect.SOUND_EFFECT_TYPE.BOAT_MOTOR_LOOP, motor_loop_duration)
