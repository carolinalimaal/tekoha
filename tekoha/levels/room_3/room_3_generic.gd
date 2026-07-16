extends State

@export var tutorial_packed_scene: PackedScene

@onready var fishing_rod: FishingRod = $"../../FishingRod"

var tutorial_instance: Node2D

func _enter() -> void:
	var current_game_state = GameManager.current_save.game_state
	
	if fishing_rod:
		fishing_rod.disable_fishing_rod_interaction()
		
	if current_game_state >= GameManager.GameState.TRAINING_COMPLETE:
		_spawn_dummy_decoration()

func _exit() -> void:
	if tutorial_instance:
		tutorial_instance.queue_free()

func _spawn_dummy_decoration() -> void:
	if tutorial_packed_scene and !tutorial_instance:
		tutorial_instance = tutorial_packed_scene.instantiate()
		owner_node.add_child(tutorial_instance)
