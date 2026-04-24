class_name DefaultButton extends Button

@export var click_sound: SoundEffect.SOUND_EFFECT_TYPE = SoundEffect.SOUND_EFFECT_TYPE.UI_FOCUS

func _ready() -> void:
	focus_entered.connect(_play_focus_sfx)
	mouse_entered.connect(_play_focus_sfx)

func _play_focus_sfx() -> void:
	AudioManager.create_audio(click_sound)
