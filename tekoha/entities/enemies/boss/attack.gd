extends State


func _enter() -> void:
	owner_node.animation_player.animation_finished.connect(_on_animation_finished)
	
func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func _exit() -> void:
	owner_node.animation_player.animation_finished.disconnect(_on_animation_finished)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["Attack", "Attack2"]:
		transition_to("Wait")
