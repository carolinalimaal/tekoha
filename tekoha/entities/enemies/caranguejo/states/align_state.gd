extends State

func _enter():
	pass

func _exit():
	pass

func _update(_delta: float):
	if not GlobalRefs.player:
		return
	var y_diff = abs(owner_node.global_position.y - GlobalRefs.player.global_position.y)
	if y_diff < owner_node.align_threshold:
		transition_to("Charge")

func _physics_update(_delta: float):
	if not GlobalRefs.player:
		owner_node.velocity = Vector2.ZERO
		return
	var y_diff = GlobalRefs.player.global_position.y - owner_node.global_position.y
	owner_node.move_direction = Vector2(0.0, sign(y_diff))
	owner_node.facing_direction = owner_node.move_direction
	owner_node.velocity = owner_node.move_direction * owner_node.chase_speed
