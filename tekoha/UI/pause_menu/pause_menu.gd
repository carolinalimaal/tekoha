extends Control

@onready var back_button: DefaultButton = $MenuOptions/Back
@onready var options_button: DefaultButton = $MenuOptions/Options
@onready var main_menu: DefaultButton = $MenuOptions/MainMenu
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	back_button.pressed.connect(_on_back_to_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	main_menu.pressed.connect(_on_back_to_main_menu_pressed)
	animation_player.play("RESET")

func grab_initial_focus() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.OPEN_MENU)
	animation_player.play("pause")
	back_button.grab_focus()

func _on_back_to_game_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.CLOSE_MENU)
	UIManager.close_top_menu()

func _on_options_pressed() -> void:
	pass

func _on_back_to_main_menu_pressed() -> void:
	GlobalRefs.confirmation_popup.setup(
		"Todo o progresso não salvo será perdido. Deseja sair?", 
		null, 
		true, 
		"Sair", 
		"Voltar"
		)
	
	if !GlobalRefs.confirmation_popup.confirmed.is_connected(_confirm_quit):
		GlobalRefs.confirmation_popup.confirmed.connect(_confirm_quit)
	if !GlobalRefs.confirmation_popup.cancelled.is_connected(_cancel_quit):
		GlobalRefs.confirmation_popup.cancelled.connect(_cancel_quit)
		
	UIManager.open_menu("confirmation")

func _confirm_quit() -> void:
	GlobalRefs.confirmation_popup.confirmed.disconnect(_confirm_quit)
	GlobalRefs.confirmation_popup.cancelled.disconnect(_cancel_quit)
	UIManager.close_all_menus()
	get_tree().change_scene_to_file("res://UI/main_menu/main_menu.tscn")

func _cancel_quit() -> void:
	GlobalRefs.confirmation_popup.confirmed.disconnect(_confirm_quit)
	GlobalRefs.confirmation_popup.cancelled.disconnect(_cancel_quit)
	UIManager.close_top_menu()
