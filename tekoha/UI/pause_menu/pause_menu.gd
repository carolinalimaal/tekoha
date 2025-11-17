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
	self.visible = false

func _process(_delta: float) -> void:
	_pause_menu()

func _pause_menu() -> void:
	if Input.is_action_just_pressed("pause") and not get_tree().paused and not is_open:
		_pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused and is_open:
		_resume()

func _pause() -> void:
	get_tree().paused = true
	_is_open = true
	self.visible = true
	animation_player.play("pause")

func _resume() -> void:
	get_tree().paused = false
	_is_open = false
	self.visible = false
	animation_player.play_backwards("pause")

func _on_back_to_game_pressed() -> void:
	_resume()

func _on_options_pressed() -> void:
	# TODO: Funcionalidade de abrir menu de opcoes
	pass

func _on_back_to_main_menu_pressed() -> void:
	_resume()
	get_tree().change_scene_to_file("res://UI/main_menu/main_menu.tscn")
