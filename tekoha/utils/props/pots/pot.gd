class_name Pote extends StaticBody2D

@export var coin_scene: PackedScene
@export var sprite_frames: SpriteFrames

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/HitboxCollision

@onready var collision: CollisionShape2D = $Collision

func _ready() -> void:
	animated_sprite_2d.sprite_frames = sprite_frames
	animated_sprite_2d.frame = 0
	y_sort_enabled = true
	z_index = 0
	
	hitbox_component.attack_received.connect(_on_pot_attack_received)
	health_component.died.connect(_on_pot_destroyed)
	
func _on_pot_attack_received(attack_data: AttackData):
	health_component.take_damage(attack_data)
	animated_sprite_2d.play("default")

func _on_pot_destroyed():
	hitbox_component.set_deferred("monitoring", false)
	hitbox_collision.set_deferred("disabled", true)
	collision.set_deferred("disabled", true)
	AudioManager.create_2d_audio_at_location(global_position, SoundEffect.SOUND_EFFECT_TYPE.BREAKING_POT)

	await animated_sprite_2d.animation_finished

	#var amount_to_drop = randi_range(0, 3)
	var chance = randf()
	var amount_to_drop = 0
	if chance < 0.15: # 15% de chance de não cair nada
		amount_to_drop = 0
	elif chance < 0.60: # 45% de chance de cair 1 moeda
		amount_to_drop = 1
	elif chance < 0.90: # 30% de chance de cair 2 moedas
		amount_to_drop = 2
	else: # 10% de chance de cair 3 moedas
		amount_to_drop = 3

	for i in range(amount_to_drop):
		_spawn_coin()

	y_sort_enabled = false
	z_index = -1

func _spawn_coin() -> void:
	if coin_scene:
		var coin_instance = coin_scene.instantiate()
		
		var start_pos = global_position
		var random_offset = Vector2(randf_range(-20.0, 20.0), randf_range(-20.0, 20.0))
		var target_pos = start_pos + random_offset
		
		get_parent().call_deferred("add_child", coin_instance)
		await get_tree().physics_frame
		coin_instance.global_position = start_pos
		coin_instance.scale = Vector2.ZERO
		
		var tween = create_tween()
		tween.set_parallel(true)
		
		tween.tween_property(coin_instance, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(coin_instance, "global_position", target_pos, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
