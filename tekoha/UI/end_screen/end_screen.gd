class_name EndScreen
extends CanvasLayer

@onready var container: VBoxContainer = $VBoxContainer
@onready var main_menu_button: DefaultButton = $VBoxContainer/MainMenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	container.modulate.a = 0.0
	main_menu_button.pressed.connect(_on_menu_pressed)

func show_screen() -> void:
	GlobalRefs.hud.hide()
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(container, "modulate:a", 1.0, 2.5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): get_tree().paused = true)
	tween.tween_callback(main_menu_button.grab_focus)

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu/main_menu.tscn")
