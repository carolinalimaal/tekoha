extends Level

@export var cutscene: DialogueSettings

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_cutscene_started)
	DialogueManager.dialogue_ended.connect(_on_cutscene_ended)
	
	if GameManager.current_save.game_state == GameManager.GameState.NEW_GAME:
		DialogueManager.start_speech(cutscene)

func _on_cutscene_started() -> void:
	pass

func _on_cutscene_ended() -> void:
	GameManager.set_game_state(GameManager.GameState.BEFORE_FISHING)
