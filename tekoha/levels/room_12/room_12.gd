extends Level

@export var bg_music: AudioStream

func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
