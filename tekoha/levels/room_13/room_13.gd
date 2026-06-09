extends Level

@onready var room_14_door: Door = $Room14Door
@onready var room_4_door: Door = $Room4Door

# TODO: adicionar loop do motor 
@export var motor_loop_sound: AudioStream

func _ready() -> void:
	if GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_2:
		room_14_door.set_deferred("monitoring", false)

	GlobalSignals.game_state_changed.connect(_on_game_state_changed)

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state == GameManager.GameState.ROOM_14_UNLOCKED:
		room_14_door.set_deferred("monitoring", true)
	elif new_state == GameManager.GameState.AFTER_PUZZLE_3:
		_start_boat_sequence()

func _start_boat_sequence() -> void:
	# TODO: registrar esse sound effect no audio manager 
	#AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.BOAT_MOTOR_START)
	GlobalSignals.animation_midpoint_reached.connect(_on_screen_black, CONNECT_ONE_SHOT)
	room_4_door.trigger_transition()

func _on_screen_black() -> void:
	if motor_loop_sound:
		AudioManager.play_background_sound(motor_loop_sound, 0.0)
