extends Node

func _process(_delta: float) -> void:
	var state_name = owner.state_machine.current_state.name
	match state_name:
		"Align":
			owner.sprite_2d.play("walk_v")
		"Charge", "Attack":
			owner.sprite_2d.play("walk_h")
