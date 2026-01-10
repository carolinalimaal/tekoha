extends Control

@onready var continue_button: Button = $Panel/VBoxContainer/HBoxContainer/ContinueButton
@onready var main_manu_button: Button = $Panel/VBoxContainer/HBoxContainer/MainMenuButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	GlobalRefs.player.player_dead.connect(_on_player_died)
	
	continue_button.pressed.connect(_on_continue_pressed)
	main_manu_button.pressed.connect(_on_main_manu_pressed)
	
	animation_player.play("RESET")
	
	self.visible = false

func _on_player_died() -> void:
	get_tree().paused = true
	self.visible = true
	animation_player.play("default")
	continue_button.grab_focus()

func _on_continue_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_manu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu/main_menu.tscn")
