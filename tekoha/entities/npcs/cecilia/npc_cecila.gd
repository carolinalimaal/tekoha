extends NPC

@export var dialogues_list: Array[DialogueSettings]

var current_dialogue_index: int = -1

func _ready() -> void:
	super()
	if GameManager.current_save.game_state < GameManager.GameState.AFTER_FIRST_ENEMY:
		npc_dialogue = dialogues_list[0]
	elif GameManager.current_save.game_state >= GameManager.GameState.AFTER_FIRST_ENEMY:
		npc_dialogue = dialogues_list[1]

func interact() -> void:
	current_dialogue_index = dialogues_list.find(npc_dialogue)
	super()

func _on_timeline_started() -> void:
	super()

func _on_timeline_ended() -> void:
	super()
	if GameManager.current_save.game_state == GameManager.GameState.TRAINING_COMPLETE:
		GameManager.set_game_state(GameManager.GameState.FIRST_MEETING_CECILIA)
	elif GameManager.current_save.game_state == GameManager.GameState.AFTER_FIRST_ENEMY:
		GameManager.set_game_state(GameManager.GameState.SECOND_MEETING_CECILIA)
