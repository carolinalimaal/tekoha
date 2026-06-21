extends Level

@export var room_2_music: AudioStream
# TODO: adicionar loop do motor 
@export var motor_loop_sound: AudioStream

@onready var path_block: PathBlock = $PathBlock
@onready var room_5_door: Door = $Room5Door

const BOAT_FADE_DURATION := 5.0

func _ready() -> void:
	if GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_3:
		path_block.set_deferred("monitoring", true)
		room_5_door.set_deferred("monitoring", false)
		GlobalRefs.game_nightfall_filter.show()
		_play_boat_going_away()
	else:
		path_block.set_deferred("monitoring", false)
		room_5_door.set_deferred("monitoring", true)
		AudioManager.play_background_sound(room_2_music)

# Rever esse metodo aqui quando tiver os SFX
func _play_boat_going_away() -> void:
	AudioManager.stop_background_sound(BOAT_FADE_DURATION)
	get_tree().create_timer(BOAT_FADE_DURATION + 0.5).timeout.connect(func():
		AudioManager.play_background_sound(motor_loop_sound)
	)
