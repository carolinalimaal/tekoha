extends StaticBody2D

var player_inside: Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gpu_particles_2d: GPUParticles2D = $Sprite2D/GPUParticles2D

var bend_speed: float = 0.2
var back_speed: float = 2

func _process(_delta) -> void:
	pass
	#expulsa o player caso ele vá para dentro do arbusto
	#if player_inside and player_inside.state_machine.current_state.name != "Roll":
		#var direction = (player_inside.global_position - global_position).normalized()
		#player_inside.global_position += direction * 10

func _on_player_roll_area_body_entered(body: Node2D) -> void:
	if body is Player and body.state_machine.current_state.name == "Roll":
		bush_anim()
		AudioManager.create_2d_audio_at_location(position, SoundEffect.SOUND_EFFECT_TYPE.BUSH)

func bush_anim():
	var tween: Tween = create_tween()
	gpu_particles_2d.emitting = true
	tween.tween_property(sprite_2d, "skew", 0.20, bend_speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite_2d, "skew", 0.0, back_speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
