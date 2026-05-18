extends State

@export var tutorial_packed_scene: PackedScene
@export var path_block_message: DialogueSettings
@onready var fishing_rod: FishingRod = $"../../FishingRod"
@onready var path_block: PathBlock = $"../../PathBlock"

var tutorial_instance: Node2D

func _enter() -> void:
	if fishing_rod:
		fishing_rod.disable_fishing_rod_interaction() 
	
	if path_block:
		path_block.path_block_message = path_block_message
		path_block.set_deferred("monitoring", true)
	
	if tutorial_packed_scene:
		tutorial_instance = tutorial_packed_scene.instantiate() 
		owner_node.add_child(tutorial_instance) 
		tutorial_instance.tutorial_finished.connect(_on_tutorial_finished)

func _exit() -> void:
	if tutorial_instance:
		if tutorial_instance.tutorial_finished.is_connected(_on_tutorial_finished):
			tutorial_instance.tutorial_finished.disconnect(_on_tutorial_finished)

func _on_tutorial_finished() -> void:
	if path_block:
		path_block.set_deferred("monitoring", false)
		path_block.hide()
	
	owner_node.change_room_state()
