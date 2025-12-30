extends AnimationTree

func _ready() -> void:
	active = true

func _process(_delta: float) -> void:
	match owner.state_machine.current_state.name:
		"Idle", "Aiming", "Lunge":
			owner.anim_transition = 0
			set("parameters/Idle/blend_position", owner.facing_direction)
		"Patrol", "Chase":
			owner.anim_transition = 1
			set("parameters/Walk/blend_position", owner.move_direction)
		"Attack":
			owner.anim_transition = 2
			set("parameters/Attack/blend_position", owner.facing_direction)
		"Stun":
			owner.anim_transition = 3
			set("parameters/Stun/blend_position", owner.facing_direction)
		"Death":
			owner.anim_transition = 4
			set("parameters/Death/blend_position", owner.facing_direction)
