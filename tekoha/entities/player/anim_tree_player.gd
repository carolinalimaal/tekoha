extends AnimationTree

func _ready() -> void:
	self.active = true

func _process(_delta: float) -> void:
	match owner.state_machine.current_state.name:
		"Idle":
			set("parameters/Idle/blend_position", owner.facing_direction)
		"Walk":
			set("parameters/Walk/blend_position", owner.move_direction)
		"Roll":
			set("parameters/Roll/blend_position", owner.move_direction)
		"Attack1":
			set("parameters/Attack_1/blend_position", owner.attack_direction)
		"AttackEnd":
			set("parameters/Attack_End/blend_position", owner.attack_direction)
		"Attack2":
			set("parameters/Attack_2/blend_position", owner.attack_direction)
		"Stun":
			set("parameters/Stun_Start/blend_position", -owner.velocity)
			set("parameters/Stun_Loop/blend_position", -owner.velocity)
