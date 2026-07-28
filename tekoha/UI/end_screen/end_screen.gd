class_name EndScreen
extends CanvasLayer

@export var credits_scene_path: String = "res://UI/credits_screen/credits_screen.tscn"
@export var button_timeout: float = 6.0

@onready var container: VBoxContainer = $VBoxContainer
@onready var credits_button: DefaultButton = $VBoxContainer/CreditsButton

var _continued: bool = false

func _ready() -> void:
	container.modulate.a = 0.0
	credits_button.pressed.connect(_on_credits_button_pressed)

func show_screen() -> void:
	GlobalRefs.hud.hide()
	get_tree().paused = true
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(container, "modulate:a", 1.0, 2.5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(credits_button.grab_focus)
	tween.tween_callback(_start_button_timeout)

func _start_button_timeout() -> void:
	get_tree().create_timer(button_timeout).timeout.connect(_on_button_timeout)

func _on_button_timeout() -> void:
	if _continued:
		return
	credits_button.hide()
	_go_to_credits()

func _on_credits_button_pressed() -> void:
	_go_to_credits()

func _go_to_credits() -> void:
	if _continued:
		return
	_continued = true
	SaveManager.delete_game()
	get_tree().paused = false
	get_tree().change_scene_to_file(credits_scene_path)
