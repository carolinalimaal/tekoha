extends Level

@export var cutscenes_list: Array[DialogueSettings]

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_cutscene_started)
	DialogueManager.dialogue_ended.connect(_on_cutscene_ended)

	if GameManager.current_save.game_state == GameManager.GameState.NEW_GAME:
		DialogueManager.start_speech(cutscenes_list[0])
	elif GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_3:
		DialogueManager.start_speech(cutscenes_list[1])

func _exit_tree() -> void:
	if DialogueManager.dialogue_started.is_connected(_on_cutscene_started):
		DialogueManager.dialogue_started.disconnect(_on_cutscene_started)
	if DialogueManager.dialogue_ended.is_connected(_on_cutscene_ended):
		DialogueManager.dialogue_ended.disconnect(_on_cutscene_ended)

func _on_cutscene_started() -> void:
	pass

func _on_cutscene_ended() -> void:
	if GameManager.current_save.game_state == GameManager.GameState.NEW_GAME:
		GameManager.set_game_state(GameManager.GameState.BEFORE_FISHING)
	elif GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_3:
		_start_sleep_sequence()

func _start_sleep_sequence() -> void:
	var canvas := CanvasLayer.new()
	var overlay := ColorRect.new()
	overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(overlay)
	add_child(canvas)

	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 1.0, 1.0)
	tween.tween_callback(_on_screen_black)
	tween.tween_property(overlay, "color:a", 0.0, 1.0)
	tween.tween_callback(canvas.queue_free)

func _on_screen_black() -> void:
	GlobalRefs.player.global_position = Vector2(45.0,15.0)
	GlobalRefs.player.facing_direction = Vector2.DOWN
	GameManager.set_game_state(GameManager.GameState.PRE_BOSSFIGHT)
	SaveManager.save_game(GameManager.current_save)
