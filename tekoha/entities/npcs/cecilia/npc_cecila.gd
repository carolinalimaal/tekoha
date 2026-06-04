extends NPC

# Possivelmente tera uma FSM aqui para decidir qual dialogo ira acontecer
# Programar isso para analisar o game_state em current_save

@export var dialogues_list: Array[DialogueSettings]

func _ready() -> void:
	super()
	# Verificar essas condicoes aqui
	if GameManager.current_save.game_state == GameManager.GameState.TRAINING_COMPLETE:
		npc_dialogue = dialogues_list[0]
	elif GameManager.current_save.game_state == GameManager.GameState.AFTER_FIRST_ENEMY:
		npc_dialogue = dialogues_list[1]

func _on_timeline_started() -> void:
	super()

func _on_timeline_ended() -> void:
	super()
	if GameManager.current_save.game_state == GameManager.GameState.TRAINING_COMPLETE:
		GameManager.set_game_state(GameManager.GameState.FIRST_MEETING_CECILIA)
	elif GameManager.current_save.game_state == GameManager.GameState.AFTER_FIRST_ENEMY:
		GameManager.set_game_state(GameManager.GameState.SECOND_MEETING_CECILIA)
