extends State

@export var cutscenes: Array[DialogueSettings]
@export var tutorial_packed_scene: PackedScene

var index: int = 0

func _enter() -> void:
	DialogueControl.dialogue_started.connect(_on_cutscene_started)
	DialogueControl.dialogue_ended.connect(_on_cutscene_ended)
	
	var tutorial_scene = tutorial_packed_scene.instantiate()
	add_child(tutorial_scene)
	
	print("sala 3.2")

func _exit() -> void:
	DialogueControl.dialogue_started.disconnect(_on_cutscene_started)
	DialogueControl.dialogue_ended.disconnect(_on_cutscene_ended)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func _on_cutscene_started() -> void:
	pass

func _on_cutscene_ended() -> void:
	pass
