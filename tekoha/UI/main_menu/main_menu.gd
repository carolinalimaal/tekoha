extends Control

@export var main_menu_music: AudioStream

@onready var menu_options: VBoxContainer = $VBoxContainer/MenuOptions
@onready var new_game_button: Button = $VBoxContainer/MenuOptions/NewGame
@onready var load_game_button: Button = $VBoxContainer/MenuOptions/LoadGame
@onready var options_button: Button = $VBoxContainer/MenuOptions/Options
@onready var quit_button: Button = $VBoxContainer/MenuOptions/Quit
@onready var background: TextureRect = $Background

@onready var confirmation_popup: Panel = $ConfirmationPopup
@onready var popup_label: Label = $ConfirmationPopup/Bg/MarginContainer/VBoxContainer/PopupLabel
@onready var confirm_button: Button = $ConfirmationPopup/Bg/MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button: Button = $ConfirmationPopup/Bg/MarginContainer/VBoxContainer/HBoxContainer/CancelButton


var bg_list: Array[Texture2D] = [
	load("res://assets/UI/bg/bg_main_menu_1.png"),
	load("res://assets/UI/bg/bg_main_menu_2.png"),
	load("res://assets/UI/bg/bg_main_menu_3.png"),
]

func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	
	new_game_button.grab_focus()
	AudioManager.play_background_sound(main_menu_music)
	
	var random_number: int = randi_range(0, 2)
	background.texture = bg_list[random_number]
	
	confirmation_popup.hide()
	
	# Verificar se existe save para mostrar ou nao o load_game_button
	GameManager.current_save = SaveManager.load_game()
	if GameManager.current_save:
		load_game_button.show()
		print("tem save")
	else:
		load_game_button.hide()
		print("nao tem save")

func _on_new_game_pressed() -> void:
	if GameManager.current_save:
		confirmation_popup.show()
		confirm_button.grab_focus()
		for b in menu_options.get_children():
			if b is Button:
				b.focus_mode = Control.FOCUS_NONE
	else:
		GameManager.current_save = SaveData.new()
		AudioManager.stop_background_sound()
		get_tree().change_scene_to_file("res://globals/main_scene/main.tscn")

func _on_load_game_pressed() -> void:
	# TODO: Funcionalidade de carregar jogo salvo
	AudioManager.stop_background_sound()
	get_tree().change_scene_to_file("res://globals/main_scene/main.tscn")

func _on_options_pressed() -> void:
	# TODO: Funcionalidade de abrir menu de opcoes
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_confirm_pressed() -> void:
	GameManager.current_save = SaveData.new()
	AudioManager.stop_background_sound()
	get_tree().change_scene_to_file("res://globals/main_scene/main.tscn")

func _on_cancel_pressed() -> void:
	confirmation_popup.hide()
	for b in menu_options.get_children():
			if b is Button:
				b.focus_mode = Control.FOCUS_ALL
	new_game_button.grab_focus()
