extends State

@export var cutscene: DialogueSettings

@onready var fishing_rod: FishingRod = $"../../FishingRod"
@onready var path_block: PathBlock = $"../../PathBlock"

func _enter() -> void:
	DialogueManager.dialogue_started.connect(_on_cutscene_started)
	DialogueManager.dialogue_ended.connect(_on_cutscene_ended)
	
	fishing_rod.fishing_rod_interated.connect(_on_player_interacted_with_fishing_rod)
	
	if fishing_rod:
		fishing_rod.enable_fishing_rod_interaction()
	
	if path_block:
		path_block.set_deferred("monitoring", false)

func _exit() -> void:
	# Limpa todos os sinais por segurança ao sair do estado
	if DialogueManager.dialogue_started.is_connected(_on_cutscene_started):
		DialogueManager.dialogue_started.disconnect(_on_cutscene_started)
	if DialogueManager.dialogue_ended.is_connected(_on_cutscene_ended):
		DialogueManager.dialogue_ended.disconnect(_on_cutscene_ended)
	if fishing_rod.fishing_rod_interated.is_connected(_on_player_interacted_with_fishing_rod):
		fishing_rod.fishing_rod_interated.disconnect(_on_player_interacted_with_fishing_rod)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func _on_player_interacted_with_fishing_rod() -> void:
	fishing_rod.disable_fishing_rod_interaction()
	DialogueManager.start_speech(cutscene)

func _on_cutscene_started() -> void:
	pass

func _on_cutscene_ended() -> void:
	GameManager.set_game_state(GameManager.GameState.FIRST_MEETING_IARA)
	owner_node.change_room_state()
