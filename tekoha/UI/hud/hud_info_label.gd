extends RichTextLabel

var _tween: Tween

func _ready() -> void:
	modulate.a = 0.0
	GlobalSignals.hud_info.connect(_on_hud_info)

func _on_hud_info(message: String) -> void:
	text = message
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 1.0, 0.15)
	_tween.tween_interval(2.0)
	_tween.tween_property(self, "modulate:a", 0.0, 0.5)
