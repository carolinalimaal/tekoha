extends Control

@export var main_menu_music: AudioStream

@onready var menu_options: VBoxContainer = $VBoxContainer/MenuOptions
@onready var new_game_button: DefaultButton = $VBoxContainer/MenuOptions/NewGame
@onready var load_game_button: DefaultButton = $VBoxContainer/MenuOptions/LoadGame
@onready var options_button: DefaultButton = $VBoxContainer/MenuOptions/Options
@onready var quit_button: DefaultButton = $VBoxContainer/MenuOptions/Quit
@onready var background: TextureRect = $Background

@onready var confirmation_popup: ConfirmationPopup = $ConfirmationPopup
@onready var navigation_legend: NavigationLegend = $NavigationLegend


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
	
	UIManager.register_menu("confirmation", confirmation_popup)
	
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

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("ui_cancel"):
		if !UIManager.menu_stack.is_empty():
			get_viewport().set_input_as_handled()
			var top_menu = UIManager.menu_stack.back()
			
			if top_menu.has_method("cancel_action"):
				top_menu.cancel_action()
			else:
				UIManager.close_top_menu()

func _on_new_game_pressed() -> void:
	if GameManager.current_save:
		navigation_legend.hide()
		confirmation_popup.setup(
			"O jogo antigo será sobrescrito, deseja continuar?", 
			null, 
			true, 
			"Continuar", 
			"Cancelar")
		UIManager.open_menu("confirmation")
		confirmation_popup.confirmed.connect(_on_confirm_new_game)
		confirmation_popup.cancelled.connect(_on_cancel_new_game)
		for b in menu_options.get_children():
			if b is Button:
				b.focus_mode = Control.FOCUS_NONE
	else:
		_start_new_game()

func _on_load_game_pressed() -> void:
	AudioManager.stop_background_sound()
	# Carrega a main e ela verifica se precisa mudar o level carregado
	get_tree().change_scene_to_file("res://globals/main_scene/main.tscn")

func _on_options_pressed() -> void:
	# TODO: Funcionalidade de abrir menu de opcoes
	pass

func _on_quit_pressed() -> void:
	navigation_legend.hide()
	confirmation_popup.setup(
		"Tem certeza que deseja sair do jogo?", 
		null, 
		true, 
		"Sair", 
		"Voltar")
	UIManager.open_menu("confirmation")
	confirmation_popup.confirmed.connect(_on_confirm_quit)
	confirmation_popup.cancelled.connect(_on_cancel_quit)
	for b in menu_options.get_children():
			if b is Button:
				b.focus_mode = Control.FOCUS_NONE

func _on_confirm_new_game() -> void:
	confirmation_popup.confirmed.disconnect(_on_confirm_new_game)
	confirmation_popup.cancelled.disconnect(_on_cancel_new_game)
	_start_new_game()

func _on_cancel_new_game() -> void:
	navigation_legend.show()
	confirmation_popup.confirmed.disconnect(_on_confirm_new_game)
	confirmation_popup.cancelled.disconnect(_on_cancel_new_game)
	UIManager.close_top_menu()
	for b in menu_options.get_children():
			if b is Button:
				b.focus_mode = Control.FOCUS_ALL
	new_game_button.grab_focus()

func _start_new_game() -> void:
	UIManager.close_all_menus()
	GameManager.current_save = SaveData.new()
	AudioManager.stop_background_sound()
	get_tree().change_scene_to_file("res://globals/main_scene/main.tscn")

func _on_confirm_quit() -> void:
	await get_tree().create_timer(0.25).timeout
	get_tree().quit()

func _on_cancel_quit() -> void:
	navigation_legend.show()
	confirmation_popup.confirmed.disconnect(_on_confirm_quit)
	confirmation_popup.cancelled.disconnect(_on_cancel_quit)
	UIManager.close_top_menu()
	for b in menu_options.get_children():
			if b is Button:
				b.focus_mode = Control.FOCUS_ALL
	quit_button.grab_focus()

func cancel_action() -> void:
	if confirmation_popup.confirm_button.text == "Continuar":
		_on_cancel_new_game()
	else:
		_on_cancel_quit()
