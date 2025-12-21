extends State

#var _nav_timer: Timer
#var _makepath_time: float = 0.5
var _distance_to_player: float

#func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	#_nav_timer = Timer.new()
	#_nav_timer.timeout.connect(_on_nav_timer_timeout)
	#_nav_timer.wait_time = _makepath_time
	#add_child(_nav_timer)

func _enter():
	#_nav_timer.start()
	pass

func _exit():
	#_nav_timer.stop()
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
		# TODO: Implementar navigation
		#owner_node.move_direction = owner_node.to_local(owner_node.nav_agent.get_next_path_position()).normalized()
		owner_node.move_direction = owner_node.get_direction_to_player()
		owner_node.velocity = owner_node.move_direction * owner_node.chase_speed
		if !owner_node.move_direction.is_zero_approx():
			owner_node.facing_direction = owner_node.move_direction

#func _makepath():
	#if GlobalRefs.player:
		#owner_node.nav_agent.target_position = GlobalRefs.player.global_position
#
#func _on_nav_timer_timeout() -> void:
	#_makepath()
