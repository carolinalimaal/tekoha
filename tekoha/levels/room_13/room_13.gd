extends Level

@export var bg_music: AudioStream

@onready var room_14_door: Door = $Room14Door
@onready var room_4_door: Door = $Room4Door


func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
	
	GlobalRefs.player.turn_light_on_or_off(false)
	
	if !GlobalRefs.game_afternoon_filter.visible:
		GlobalRefs.game_afternoon_filter.show()
	
	if GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_2:
		room_14_door.set_deferred("monitoring", false)

	GlobalSignals.game_state_changed.connect(_on_game_state_changed)

func _exit_tree() -> void:
	if GlobalSignals.game_state_changed.is_connected(_on_game_state_changed):
		GlobalSignals.game_state_changed.disconnect(_on_game_state_changed)

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state == GameManager.GameState.ROOM_14_UNLOCKED:
		room_14_door.set_deferred("monitoring", true)
	elif new_state == GameManager.GameState.AFTER_PUZZLE_3:
		_start_boat_sequence()

func _start_boat_sequence() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.BOAT_MOTOR_START)
	var start_duration = AudioManager.get_sound_effect_duration(SoundEffect.SOUND_EFFECT_TYPE.BOAT_MOTOR_START)
	room_4_door.trigger_transition(start_duration)
