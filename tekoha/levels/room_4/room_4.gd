extends Level

@export var room_2_music: AudioStream

func _ready() -> void:
	AudioManager.play_background_sound(room_2_music)
