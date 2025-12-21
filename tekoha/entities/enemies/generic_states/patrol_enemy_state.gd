class_name PatrolEnemyState 
extends State

var _patrol_timer: Timer
var _distance_to_player: float

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_patrol_timer = Timer.new()
	_patrol_timer.one_shot = true
	_patrol_timer.timeout.connect(_on_patrol_timer_timeout)
	add_child(_patrol_timer)

func _enter():
	# Randomizar tempo de patrulha e iniciar timer
	_randomize_patrol_time()
	_patrol_timer.start()

func _exit():
	_patrol_timer.stop()

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player < owner_node.chase_range_sqr:
			transition_to("Chase")
			return

func _physics_update(_delta: float):
	# Atualizar velocidade e facing_direction
	owner_node.velocity = owner_node.move_direction * owner_node.patrol_speed
	owner_node.facing_direction = owner_node.move_direction

func _randomize_patrol_time():
	owner_node.move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	_patrol_timer.wait_time = randf_range(1, 2)

func _on_patrol_timer_timeout():
	transition_to("Idle")
	return
