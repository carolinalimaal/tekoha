class_name Torch extends StaticBody2D

signal puzzle_activator()

@export var torch_id: int

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/HitBoxCollision
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var torche_particles: GPUParticles2D = $TorcheParticles
@onready var fire_loop_player: AudioStreamPlayer2D = $FireLoopPlayer

@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	hitbox_component.attack_received.connect(_on_torch_attack_received)
	if GameManager.current_save.game_state >= GameManager.GameState.AFTER_PUZZLE_1:
		animated_sprite_2d.play("third_hit")
		torch_off_particles()
	else:
		animated_sprite_2d.play("default")
		torche_particles.emitting = true
		_start_fire_loop()

func _on_torch_attack_received(_attack_data: AttackData):
	stronger_light()
	if _attack_data.damage_value < 6:
		animated_sprite_2d.play("first_hit")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("default")
	else:
		AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.TORCH_EXTINGUISH)
		animated_sprite_2d.play("second_hit")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("third_hit")
		torch_off()

func torch_off():
	var tween: Tween = create_tween()
	tween.tween_property(point_light_2d, "energy", 0, 0.2)
	torch_off_particles()
	_stop_fire_loop()
	hitbox_component.set_deferred("monitoring", false)
	hitbox_collision.set_deferred("disabled", true)
	point_light_2d.set_deferred("disabled", true)
	puzzle_activator.emit()

func stronger_light():
	var tween: Tween = create_tween()
	var gradient_text: GradientTexture2D = point_light_2d.texture
	
	hit_particles.emitting = true
	tween.tween_property(point_light_2d, "energy", 0.8, 0.1)
	tween.tween_property(gradient_text, "fill_to", Vector2(1.15, 0), 0.1)
	tween.tween_property(gradient_text, "fill_to", Vector2(1.0, 0), 0.3)
	tween.tween_property(point_light_2d, "energy", 0.5, 0.3)
	
func torch_off_particles():
	point_light_2d.energy = 0
	point_light_2d.set_deferred("disabled", true)
	torche_particles.emitting = false
	hit_particles.emitting = false

func _start_fire_loop():
	if fire_loop_player.playing:
		return
	fire_loop_player.finished.connect(fire_loop_player.play)
	fire_loop_player.play()

func _stop_fire_loop():
	if fire_loop_player.finished.is_connected(fire_loop_player.play):
		fire_loop_player.finished.disconnect(fire_loop_player.play)
	fire_loop_player.stop()
