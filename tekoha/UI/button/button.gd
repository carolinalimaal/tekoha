class_name DefaultButton extends Button

#@export var hover_sound: SoundEffect.SOUND_EFFECT_TYPE = SoundEffect.SOUND_EFFECT_TYPE.UI_HOVER
@export var click_sound: SoundEffect.SOUND_EFFECT_TYPE = SoundEffect.SOUND_EFFECT_TYPE.UI_CLICK

func _ready() -> void:
	mouse_entered.connect(_play_hover_sfx)
	focus_entered.connect(_play_hover_sfx)
	pressed.connect(_play_click_sfx)

func _play_hover_sfx() -> void:
	#AudioManager.create_audio(hover_sound)
	pass

func _play_click_sfx() -> void:
	AudioManager.create_audio(click_sound)
