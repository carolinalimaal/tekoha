extends State

@export var cutscenes: Array[DialogueSettings]
@export var practice_dummy_scene: PackedScene

var index: int = 0

func _enter() -> void:
	DialogueManager.dialogue_started.connect(_on_cutscene_started)
	DialogueManager.dialogue_ended.connect(_on_cutscene_ended)
	
	var practice_dummy_instance = practice_dummy_scene.instantiate()
	add_child(practice_dummy_instance)
	
	print("sala 3.2")

func _exit() -> void:
	DialogueManager.dialogue_started.disconnect(_on_cutscene_started)
	DialogueManager.dialogue_ended.disconnect(_on_cutscene_ended)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func _on_cutscene_started() -> void:
	pass

func _on_cutscene_ended() -> void:
	pass
