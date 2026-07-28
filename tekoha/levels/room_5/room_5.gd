extends Level

@export var bg_music: MusicTrack

func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
