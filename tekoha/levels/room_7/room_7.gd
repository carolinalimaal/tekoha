extends Level

@onready var room_7_door: Door = $Room7Door
@onready var path_block: PathBlock = $PathBlock

func _ready() -> void:
	if GameManager.current_save.game_state == GameManager.GameState.SECOND_MEETING_CECILIA:
		GameManager.set_game_state(GameManager.GameState.IN_KITCHEN)
		_auto_save()

	var in_kitchen = GameManager.current_save.game_state >= GameManager.GameState.IN_KITCHEN
	room_7_door.monitoring = !in_kitchen
	path_block.monitoring = in_kitchen

func _auto_save() -> void:
	await get_tree().process_frame
	SaveManager.save_game(GameManager.current_save)
