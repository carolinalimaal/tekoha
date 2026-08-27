extends Level

# TODO: trocar para a bg_music do puzzle
@export var bg_music: MusicTrack

@onready var root_mecanic: RootMecanic = $RootMecanic
@onready var music_trigger: Area2D = $MusicTrigger

func _ready() -> void:	
	if GameManager.current_save.game_state >= GameManager.GameState.AFTER_PUZZLE_2:
		root_mecanic.set_completed()
		music_trigger.monitoring = false
		return

	root_mecanic.puzzle_completed.connect(_on_puzzle_completed)
	music_trigger.body_entered.connect(_on_player_entered_puzzle_area)

func _exit_tree() -> void:
	if root_mecanic.puzzle_completed.is_connected(_on_puzzle_completed):
		root_mecanic.puzzle_completed.disconnect(_on_puzzle_completed)

func _on_puzzle_completed() -> void:
	GameManager.set_game_state(GameManager.GameState.AFTER_PUZZLE_2)
	AudioManager.stop_background_sound(5.0)

func _on_player_entered_puzzle_area(body: Node2D) -> void:
	if body is Player:
		if bg_music != null:
			AudioManager.play_background_sound(bg_music)
