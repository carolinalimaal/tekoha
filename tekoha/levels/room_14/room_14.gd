extends Level

func _ready() -> void:
	AudioManager.stop_background_sound()
	GlobalRefs.game_afternoon_filter.hide()
	GlobalRefs.player.turn_light_on_or_off(true)
