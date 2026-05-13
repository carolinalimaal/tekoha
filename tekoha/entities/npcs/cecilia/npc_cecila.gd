extends NPC

# Possivelmente tera uma FSM aqui para decidir qual dialogo ira acontecer
# Programar isso para analisar o game_state em current_save

@export var dialogues_list: Array[DialogueSettings]

func _ready() -> void:
	super()
	# Verificar essas condicoes aqui
	if GameManager.current_save.game_state:
		npc_dialogue = dialogues_list[0]

func _on_timeline_started() -> void:
	super()

func _on_timeline_ended() -> void:
	super()
