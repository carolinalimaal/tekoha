class_name DefaultButton extends Button

@export var houver_sound: SoundEffect.SOUND_EFFECT_TYPE = SoundEffect.SOUND_EFFECT_TYPE.BUTTON_FOCUS
@export var click_sound: SoundEffect.SOUND_EFFECT_TYPE = SoundEffect.SOUND_EFFECT_TYPE.BUTTON_CLICK

var original_scale: Vector2 = Vector2.ONE
var _pressing: bool = false

func _ready() -> void:
	pivot_offset = size / 2.0
	original_scale = scale

	focus_entered.connect(_on_focus_or_hover)
	mouse_entered.connect(_on_focus_or_hover)

	focus_exited.connect(_on_normal_state)
	mouse_exited.connect(_on_normal_state)

	button_down.connect(_on_pressed_state)
	button_up.connect(_on_release_state)

func _on_focus_or_hover() -> void:
	if not _pressing:
		AudioManager.create_audio(houver_sound)

	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", original_scale * 1.1, 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2, 1.0), 0.1)

func _on_normal_state() -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", original_scale, 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)

func _on_pressed_state() -> void:
	_pressing = true
	AudioManager.create_audio(click_sound)
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", original_scale * 0.9, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", Color(0.7, 0.7, 0.7, 1.0), 0.1)

func _on_release_state() -> void:
	_pressing = false
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", original_scale * 1.1, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2, 1.0), 0.1)
