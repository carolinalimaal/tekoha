extends State

var _surround_timer: Timer
var _circle_direction: int = 1
var _distance_to_player: float

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_surround_timer = Timer.new()
	_surround_timer.one_shot = true
	_surround_timer.timeout.connect(_on_surround_timer_timeout)
	add_child(_surround_timer)

func _enter():
	# Escolher uma direção para rodear
	_circle_direction = [-1,1].pick_random()
	# Randomizar tempo rodeando e iniciar o timer
	_surround_timer.wait_time = randf_range(1.0, 2.0)
	_surround_timer.start()

func _exit():
	_surround_timer.stop()

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player > owner_node.aiming_range_sqr:
			transition_to("Chase")
			return

func _physics_update(_delta: float):
	if GlobalRefs.player:
		# Calcular movimento em círculo
		var vector_player_to_enemy = owner_node.global_position - GlobalRefs.player.global_position
		var orbit_vector = vector_player_to_enemy.rotated(0.25 * _circle_direction)
		var target_orbit_position = GlobalRefs.player.global_position + orbit_vector.normalized() * owner_node.aiming_range
		var direction_to_target = (target_orbit_position - owner_node.global_position).normalized()
		
		# Atualizar facing_direction, move_irection e velocidade
		owner_node.facing_direction = owner_node.get_direction_to_player()
		owner_node.move_direction = direction_to_target
		owner_node.velocity = owner_node.move_direction * owner_node.patrol_speed

func _on_surround_timer_timeout() -> void:
	# Decisão da próxima ação
	if owner_node.can_attack and owner_node.is_attack_allowed():
		transition_to("Attack")
		return
	else:
		transition_to("Pause")
		return
