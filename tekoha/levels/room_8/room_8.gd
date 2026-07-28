extends Level

@export var bg_music: MusicTrack

@onready var room_8_door: Door = $Room8Door

func  _ready() -> void:
	AudioManager.play_background_sound(bg_music)
	if GameManager.current_save.game_state == GameManager.GameState.AFTER_CECILIA_GIFT:
		GameManager.set_game_state(GameManager.GameState.IN_ROOM_8)
		_auto_save()
	
	GlobalRefs.game_afternoon_filter.show()
	
	room_8_door.set_deferred("monitoring", false)
	

func _auto_save() -> void:
	await get_tree().process_frame
	SaveManager.save_game(GameManager.current_save)
