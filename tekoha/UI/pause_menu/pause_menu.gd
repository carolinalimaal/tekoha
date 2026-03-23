extends Control

@onready var back_to_game_button: Button = $MenuOptions/BackToGame
@onready var options_button: Button = $MenuOptions/Options
@onready var back_to_main_menu_button: Button = $MenuOptions/BackToMainMenu
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _is_open : bool = false

func _ready() -> void:
	back_to_game_button.pressed.connect(_on_back_to_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	back_to_main_menu_button.pressed.connect(_on_back_to_main_menu_pressed)
	
	animation_player.play("RESET")
	
	self.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("pause"):
		if _is_open and get_tree().paused:
			_resume()
		elif !_is_open and !get_tree().paused:
			_pause()

func _pause() -> void:
	get_tree().paused = true
	_is_open = true
	self.show()
	animation_player.play("pause")
	back_to_game_button.grab_focus()

func _resume() -> void:
	get_tree().paused = false
	_is_open = false
	self.hide()
	animation_player.play_backwards("pause")

func _on_back_to_game_pressed() -> void:
	_resume()

func _on_options_pressed() -> void:
	# TODO: Funcionalidade de abrir menu de opcoes
	pass

func _on_back_to_main_menu_pressed() -> void:
	_resume()
	get_tree().change_scene_to_file("res://UI/main_menu/main_menu.tscn")
