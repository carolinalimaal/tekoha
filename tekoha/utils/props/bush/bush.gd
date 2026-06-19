extends StaticBody2D

var player_inside: Player

func _process(_delta) -> void:
	pass
	#expulsa o player caso ele vá para dentro do arbusto
	#if player_inside and player_inside.state_machine.current_state.name != "Roll":
		#var direction = (player_inside.global_position - global_position).normalized()
		#player_inside.global_position += direction * 10

func _on_player_roll_area_body_entered(body: Node2D) -> void:
	if body is Player and body.state_machine.current_state.name == "Roll":
		AudioManager.create_2d_audio_at_location(position, SoundEffect.SOUND_EFFECT_TYPE.BUSH)
