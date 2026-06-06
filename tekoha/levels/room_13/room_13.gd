extends Level

@onready var room_14_door: Door = $Room14Door

func _ready() -> void:
	if GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_2:
		room_14_door.set_deferred("monitoring", false)
	
	GlobalSignals.game_state_changed.connect(_on_game_state_changed)

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state == GameManager.GameState.ROOM_14_UNLOCKED:
		room_14_door.set_deferred("monitoring", true)
