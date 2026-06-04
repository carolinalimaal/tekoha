extends Level

@onready var roll_mecanic: Node2D = $RollMecanic

func _ready() -> void:
	if GameManager.current_save.game_state < GameManager.GameState.SECOND_MEETING_CECILIA:
		roll_mecanic.disable()
	else:
		roll_mecanic.enable()
	GlobalSignals.game_state_changed.connect(_on_game_state_changed)

func _exit_tree() -> void:
	GlobalSignals.game_state_changed.disconnect(_on_game_state_changed)

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state >= GameManager.GameState.SECOND_MEETING_CECILIA:
		roll_mecanic.enable()
	else:
		roll_mecanic.disable()
