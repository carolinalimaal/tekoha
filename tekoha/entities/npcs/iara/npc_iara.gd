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
		GameManager.GameState.PRE_BOSSFIGHT:
			GameManager.set_game_state(GameManager.GameState.BOSSFIGHT)
			# TODO: Teletransportar o Curupira para a arena da bossfight
