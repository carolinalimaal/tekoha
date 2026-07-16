extends State

@export var tutorial_packed_scene: PackedScene
@export var path_block_message: DialogueSettings
@export var training_start_dialogue: DialogueSettings
@export var training_finish_dialogue: DialogueSettings
@onready var fishing_rod: FishingRod = $"../../FishingRod"
@onready var path_block: PathBlock = $"../../PathBlock"

const DELAY_BEFORE_REVEAL := 1.0

var tutorial_instance: Node2D

enum Phase { INTRO, TUTORIAL, END }
var current_phase: Phase = Phase.INTRO

func _enter() -> void:
	current_phase = Phase.INTRO
	owner_node.show_transition_overlay()
	
	if fishing_rod:
		fishing_rod.disable_fishing_rod_interaction()
	
	if path_block:
		path_block.path_block_message = path_block_message
		path_block.set_deferred("monitoring", true)
	
	if tutorial_packed_scene:
		tutorial_instance = tutorial_packed_scene.instantiate()
		owner_node.add_child(tutorial_instance)
		tutorial_instance.tutorial_finished.connect(_on_tutorial_finished)
		tutorial_instance.player_reposition_respawn()
	
	await get_tree().create_timer(DELAY_BEFORE_REVEAL).timeout
	owner_node.hide_transition_overlay()
	
	if training_start_dialogue:
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
		DialogueManager.start_speech(training_start_dialogue)
	else:
		_start_tutorial()

func _exit() -> void:
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	if tutorial_instance:
		if tutorial_instance.tutorial_finished.is_connected(_on_tutorial_finished):
			tutorial_instance.tutorial_finished.disconnect(_on_tutorial_finished)

func _on_dialogue_ended() -> void:
	match current_phase:
		Phase.INTRO:
			DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
			current_phase = Phase.TUTORIAL
			_start_tutorial()
		Phase.END:
			DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
			_finish_training()

func _start_tutorial() -> void:
	if tutorial_instance:
		tutorial_instance.interact()

func _on_tutorial_finished() -> void:
	if path_block:
		path_block.set_deferred("monitoring", false)
		path_block.hide()

	if training_finish_dialogue:
		current_phase = Phase.END
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
		DialogueManager.start_speech(training_finish_dialogue)
	else:
		_finish_training()

func _finish_training() -> void:
	GameManager.set_game_state(GameManager.GameState.TRAINING_COMPLETE)
	owner_node.change_room_state()
