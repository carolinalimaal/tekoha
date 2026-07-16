extends NPC

@export var dialogues_list: Array[DialogueSettings]

var current_dialogue_index: int = -1

func interact() -> void:
	current_dialogue_index = dialogues_list.find(npc_dialogue)
	super()

func _on_timeline_ended() -> void:
	super()
	if current_dialogue_index == -1:
		return

	match GameManager.current_save.game_state:
		GameManager.GameState.TRAINING_COMPLETE:
			GameManager.set_game_state(GameManager.GameState.FIRST_MEETING_CECILIA)
		GameManager.GameState.AFTER_FIRST_ENEMY:
			GameManager.set_game_state(GameManager.GameState.SECOND_MEETING_CECILIA)
		GameManager.GameState.IN_KITCHEN:
			GameManager.set_game_state(GameManager.GameState.AFTER_CECILIA_GIFT)

	current_dialogue_index = -1
