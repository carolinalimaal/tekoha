extends Level

# TODO: trocar para a bg_music do puzzle
@export var bg_music: AudioStream

func _ready() -> void:
	AudioManager.stop_background_sound()
	#AudioManager.play_background_sound(bg_music)
	GlobalRefs.game_afternoon_filter.hide()
	GlobalRefs.player.turn_light_on_or_off(true)
