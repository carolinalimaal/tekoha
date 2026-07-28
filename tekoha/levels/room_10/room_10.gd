extends Level

# TODO: trocar para a bg_music do puzzle
@export var bg_music: MusicTrack

@onready var root_mecanic: RootMecanic = $RootMecanic

func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
	
	if GameManager.current_save.game_state >= GameManager.GameState.AFTER_PUZZLE_1:
		root_mecanic.set_completed()
		return

	root_mecanic.puzzle_completed.connect(_on_puzzle_completed)

func _exit_tree() -> void:
	if root_mecanic.puzzle_completed.is_connected(_on_puzzle_completed):
		root_mecanic.puzzle_completed.disconnect(_on_puzzle_completed)

func _on_puzzle_completed() -> void:
	GameManager.set_game_state(GameManager.GameState.AFTER_PUZZLE_1)
