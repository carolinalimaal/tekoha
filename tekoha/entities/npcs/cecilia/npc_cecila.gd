extends NPC

@export var dialogues_list: Array[DialogueSettings]

var current_dialogue_index: int = -1
var _is_own_dialogue: bool = false

func interact() -> void:
	current_dialogue_index = dialogues_list.find(npc_dialogue)
	_is_own_dialogue = true
	super()

func _on_timeline_ended() -> void:
	super()
	if !_is_own_dialogue:
		return
	_is_own_dialogue = false

	match GameManager.current_save.game_state:
		GameManager.GameState.TRAINING_COMPLETE:
			GameManager.set_game_state(GameManager.GameState.FIRST_MEETING_CECILIA)
		GameManager.GameState.AFTER_FIRST_ENEMY:
			GameManager.set_game_state(GameManager.GameState.SECOND_MEETING_CECILIA)
		GameManager.GameState.IN_KITCHEN:
			GameManager.set_game_state(GameManager.GameState.AFTER_CECILIA_GIFT)
