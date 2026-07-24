extends State

var _nav_timer: Timer
var _makepath_time: float = 0.5
var _distance_to_player: float

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_nav_timer = Timer.new()
	_nav_timer.timeout.connect(_on_nav_timer_timeout)
	_nav_timer.wait_time = _makepath_time
	add_child(_nav_timer)

func _enter():
	if owner_node.never_seen_player:
		owner_node.never_seen_player = false
		AudioManager.create_2d_audio_at_location(owner_node.global_position, SoundEffect.SOUND_EFFECT_TYPE.ENEMY_ALERT)
		await _play_alert_animation()
	
	_nav_timer.start()

func _exit():
	_nav_timer.stop()
	pass

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player < owner_node.aiming_range_sqr:
			transition_to("Surround")
			return

func _physics_update(_delta: float):
	if GlobalRefs.player:
		owner_node.move_direction = owner_node.global_position.direction_to(owner_node.nav_agent.get_next_path_position())
		owner_node.velocity = owner_node.move_direction * owner_node.chase_speed
		if !owner_node.move_direction.is_zero_approx():
			owner_node.facing_direction = owner_node.move_direction

func _makepath():
	if GlobalRefs.player:
		owner_node.nav_agent.target_position = GlobalRefs.player.global_position
#
func _on_nav_timer_timeout() -> void:
	_makepath()

func _play_alert_animation() -> void:
	owner_node.alert_sprite.visible = true
	var tween = create_tween()
	
	for i in range(3):
		tween.tween_property(owner_node.alert_sprite, "modulate:a", 0.0, 0.15)
		tween.tween_property(owner_node.alert_sprite, "modulate:a", 1.0, 0.15)
		
	await tween.finished
	
	owner_node.alert_sprite.visible = false
	owner_node.alert_sprite.modulate.a = 1.0
