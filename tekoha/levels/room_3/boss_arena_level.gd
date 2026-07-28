class_name BossArenaLevel
extends Level

@export var pos_boss_cutscene: DialogueSettings

@onready var boss: Node2D = $Boss

var _end_screen: EndScreen

func _ready() -> void:
	boss.death_sequence_finished.connect(_on_boss_defeated, CONNECT_ONE_SHOT)

func _on_boss_defeated() -> void:
	GameManager.set_game_state(GameManager.GameState.POS_BOSSFIGHT)
	if pos_boss_cutscene:
		DialogueManager.dialogue_finishing.connect(_on_cutscene_finishing, CONNECT_ONE_SHOT)
		DialogueManager.dialogue_ended.connect(_on_cutscene_ended, CONNECT_ONE_SHOT)
		DialogueManager.start_speech(pos_boss_cutscene)
	else:
		_get_end_screen().show_screen()

func _on_cutscene_finishing() -> void:
	_get_end_screen()

func _on_cutscene_ended() -> void:
	_get_end_screen().show_screen()

func _get_end_screen() -> EndScreen:
	if !_end_screen:
		_end_screen = load("res://UI/end_screen/end_screen.tscn").instantiate()
		add_child(_end_screen)
	return _end_screen
