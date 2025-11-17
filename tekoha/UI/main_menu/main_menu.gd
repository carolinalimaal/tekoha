extends Control

@onready var new_game_button: Button = $VBoxContainer/MenuOptions/NewGame
@onready var load_game_button: Button = $VBoxContainer/MenuOptions/LoadGame
@onready var options_button: Button = $VBoxContainer/MenuOptions/Options
@onready var quit_button: Button = $VBoxContainer/MenuOptions/Quit
@onready var background: TextureRect = $Background


var bg_list: Array[Texture2D] = [
	preload("res://assets/UI/bg/bg_main_menu_1.png"),
	preload("res://assets/UI/bg/bg_main_menu_2.png"),
	preload("res://assets/UI/bg/bg_main_menu_3.png"),
]

func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	new_game_button.grab_focus()
	
	var random_number: int = randi_range(0, 2)
	background.texture = bg_list[random_number]

func _on_new_game_pressed() -> void:
	# TODO: Funcionalidade de novo jogo
	pass

func _on_load_game_pressed() -> void:
	# TODO: Funcionalidade de carregar jogo salvo
	get_tree().change_scene_to_file("res://globals/main_scene/main.tscn")

func _on_options_pressed() -> void:
	# TODO: Funcionalidade de abrir menu de opcoes
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
