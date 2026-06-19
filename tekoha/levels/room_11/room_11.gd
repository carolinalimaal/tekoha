extends Level

@onready var root_mecanic: RootMecanic = $RootMecanic

func _ready() -> void:
	if GameManager.current_save.game_state >= GameManager.GameState.AFTER_PUZZLE_2:
		root_mecanic.set_completed()
		return

	root_mecanic.puzzle_completed.connect(_on_puzzle_completed)

func _exit_tree() -> void:
	if root_mecanic.puzzle_completed.is_connected(_on_puzzle_completed):
		root_mecanic.puzzle_completed.disconnect(_on_puzzle_completed)

func _on_puzzle_completed() -> void:
	GameManager.set_game_state(GameManager.GameState.AFTER_PUZZLE_2)
