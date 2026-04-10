extends State

@export var cutscene: DialogueSettings

@onready var fishing_rod: FishingRod = $FishingRod

func _enter() -> void:
	DialogueControl.dialogue_started.connect(_on_cutscene_started)
	DialogueControl.dialogue_ended.connect(_on_cutscene_ended)

	fishing_rod.fishing_rod_interated.connect(_on_player_interacted_with_fishing_rod)
	
	if GameManager.current_save.game_state == GameManager.GameState.FIRST_MEETING_IARA:
		transition_to("3_2")
	
	fishing_rod.show()
	

func _exit() -> void:
	DialogueControl.dialogue_started.disconnect(_on_cutscene_started)
	DialogueControl.dialogue_ended.disconnect(_on_cutscene_ended)
	
	fishing_rod.fishing_rod_interated.disconnect(_on_player_interacted_with_fishing_rod)

func _update(_delta: float) -> void:
	
	pass

func _physics_update(_delta: float) -> void:
	pass

func _on_player_interacted_with_fishing_rod() -> void:
	if GameManager.current_save.game_state == GameManager.GameState.BEFORE_FISHING:
		DialogueControl.start_speech(cutscene)

func _on_cutscene_started() -> void:
	pass

func _on_cutscene_ended() -> void:
	GameManager.current_save.game_state = GameManager.GameState.FIRST_MEETING_IARA
	fishing_rod.has_interacted = true
	
	transition_to("3_2")
