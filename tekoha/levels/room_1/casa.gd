extends Level

@export var cutscene: DialogueSettings

func _ready() -> void:
	DialogueControl.dialogue_started.connect(_on_cutscene_started)
	DialogueControl.dialogue_ended.connect(_on_cutscene_ended)
	
	if GameManager.current_save.game_state == 0:
		DialogueControl.start_speech(cutscene)

func _on_cutscene_started() -> void:
	pass

func _on_cutscene_ended() -> void:
	GameManager.current_save.game_state = 1
