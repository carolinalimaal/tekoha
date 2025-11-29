class_name PausingEnemyState 
extends State

var _pause_timer: Timer
var _distance_to_player: float

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_pause_timer = Timer.new()
	_pause_timer.one_shot = true
	_pause_timer.timeout.connect(_on_pause_timer_timeout)
	add_child(_pause_timer)

func _enter():
	owner_node.velocity = Vector2.ZERO
	
	_pause_timer.wait_time = randf_range(0.5, 1.0)
	_pause_timer.start()

func _exit():
	_pause_timer.stop()

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player > owner_node.circling_range_sqr:
			transition_to("chase")
			return
		if _distance_to_player < owner_node.retreat_range_sqr:
			transition_to("retreat")
			return

func _physics_update(_delta: float):
	if GlobalRefs.player:
		# Atualizar facing_direction
		owner_node.facing_direction = owner_node.get_direction_to_player()

func _on_pause_timer_timeout():
	transition_to("circling")
	return
