extends NPC

@export var dialogues_list: Array[DialogueSettings]


func _ready() -> void:
	super()
	if GameManager.current_save.game_state < GameManager.GameState.ROOM_14_UNLOCKED:
		npc_dialogue = dialogues_list[0]
	elif GameManager.current_save.game_state == GameManager.GameState.ROOM_14_UNLOCKED:
		npc_dialogue = dialogues_list[1]
	elif GameManager.current_save.game_state == GameManager.GameState.TOOLS_COLLECTED:
		npc_dialogue = dialogues_list[2]
	elif GameManager.current_save.game_state >= GameManager.GameState.AFTER_PUZZLE_3:
		npc_dialogue = dialogues_list[3]

func _on_timeline_started() -> void:
	super()

func _on_timeline_ended() -> void:
	super()
	if GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_2:
		GameManager.set_game_state(GameManager.GameState.ROOM_14_UNLOCKED)
	elif GameManager.current_save.game_state == GameManager.GameState.TOOLS_COLLECTED:
		GameManager.set_game_state(GameManager.GameState.AFTER_PUZZLE_3)
