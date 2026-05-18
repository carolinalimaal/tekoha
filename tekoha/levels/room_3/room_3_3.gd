extends State

@export var cutscene_1: DialogueSettings
@export var cutscene_2: DialogueSettings
@export var tutorial_packed_scene: PackedScene
@export var enemy_scene: PackedScene
@export var enemy_spawn_position: Marker2D
@export var path_block_message: DialogueSettings

@onready var fishing_rod: FishingRod = $"../../FishingRod"
@onready var path_block: PathBlock = $"../../PathBlock"

var tutorial_instance: Node2D
var enemy_instance: Node2D

enum Phase { FISHING, CUTSCENE_1, COMBAT, CUTSCENE_2 }
var current_phase: Phase = Phase.FISHING

func _enter() -> void:
	current_phase = Phase.FISHING
	
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	if path_block:
		path_block.path_block_message = path_block_message
	
	if fishing_rod:
		fishing_rod.enable_fishing_rod_interaction()
		if !fishing_rod.fishing_rod_interated.is_connected(_on_fishing_rod_interacted):
			fishing_rod.fishing_rod_interated.connect(_on_fishing_rod_interacted)
	
	if tutorial_packed_scene:
		tutorial_instance = tutorial_packed_scene.instantiate()
		owner_node.add_child(tutorial_instance)
		tutorial_instance.disable_tutorial_interaction()

func _exit() -> void:
	# Limpeza rigorosa de sinais e instâncias
	if DialogueManager.dialogue_started.is_connected(_on_dialogue_started):
		DialogueManager.dialogue_started.disconnect(_on_dialogue_started)
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
		
	if fishing_rod and fishing_rod.fishing_rod_interated.is_connected(_on_fishing_rod_interacted):
		fishing_rod.fishing_rod_interated.disconnect(_on_fishing_rod_interacted)
		
	if tutorial_instance:
		tutorial_instance.queue_free()

func _on_fishing_rod_interacted() -> void:
	fishing_rod.disable_fishing_rod_interaction()
	current_phase = Phase.CUTSCENE_1
	DialogueManager.start_speech(cutscene_1)

func _on_dialogue_started() -> void:
	pass

func _on_dialogue_ended() -> void:
	match current_phase:
		Phase.CUTSCENE_1:
			_start_combat()
		Phase.CUTSCENE_2:
			_finish_state()

func _start_combat() -> void:
	current_phase = Phase.COMBAT
	
	if enemy_scene:
		enemy_instance = enemy_scene.instantiate()
		owner_node.add_child(enemy_instance)
		
		if enemy_spawn_position:
			enemy_instance.global_position = enemy_spawn_position.global_position
		path_block.set_deferred("monitoring", true)
		enemy_instance.tree_exited.connect(_on_enemy_defeated)

func _on_enemy_defeated() -> void:
	if current_phase == Phase.COMBAT:
		current_phase = Phase.CUTSCENE_2
		DialogueManager.start_speech(cutscene_2)

func _finish_state() -> void:
	if path_block:
		path_block.set_deferred("monitoring", false)
	GameManager.set_game_state(GameManager.GameState.AFTER_FIRST_ENEMY)
	owner_node.change_room_state()
