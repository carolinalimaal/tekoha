extends AnimationTree

func _ready() -> void:
	self.active = true

func _process(_delta: float) -> void:
	match owner.state_machine.current_state.name:
		"Idle":
			owner.anim_transition = 0
			set("parameters/Idle/blend_position", owner.facing_direction)
		"Walk":
			owner.anim_transition = 1
			set("parameters/Walk/blend_position", owner.move_direction)
		"Roll":
			owner.anim_transition = 2
			set("parameters/Roll/blend_position", owner.roll_direction)
		"Attack1":
			owner.anim_transition = 3
			set("parameters/Attack_1/blend_position", owner.attack_direction)
		"AttackEnd":
			owner.anim_transition = 4
			set("parameters/Attack_End/blend_position", owner.attack_direction)
		"Attack2":
			owner.anim_transition = 5
			set("parameters/Attack_2/blend_position", owner.attack_direction)
		"Stun":
			owner.anim_transition = 6
			set("parameters/Stun/blend_position", -owner.velocity)
		"Death":
			owner.anim_transition = 7
			set("parameters/Death/blend_position", -owner.velocity)
