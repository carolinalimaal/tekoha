class_name DefaultButton extends Button

@export var click_sound: SoundEffect.SOUND_EFFECT_TYPE = SoundEffect.SOUND_EFFECT_TYPE.UI_CLICK

func _ready() -> void:
	pressed.connect(_play_click_sfx)

func _play_click_sfx() -> void:
	AudioManager.create_audio(click_sound)
