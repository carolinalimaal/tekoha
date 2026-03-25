extends StaticBody2D

var player_inside: Player

func _process(_delta) -> void:
	#expulsa o player caso ele vá para dentro do arbusto
	if player_inside and player_inside.state_machine.current_state.name != "Roll":
		var direction = (player_inside.global_position - global_position).normalized()
		player_inside.global_position += direction * 10


func _on_player_roll_area_body_entered(body: Node2D) -> void:
	if body is Player and body.state_machine.current_state.name == "Roll":
		player_inside = body
		set_collision_layer_value(9, false)


func _on_player_roll_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside = null
		set_collision_layer_value(9, true)
