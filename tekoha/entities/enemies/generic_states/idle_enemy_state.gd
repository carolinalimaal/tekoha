class_name IdleEnemyState
extends State

var _idle_timer: Timer
var _distance_to_player: float

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_idle_timer = Timer.new()
	_idle_timer.one_shot = true
	_idle_timer.timeout.connect(_on_idle_timer_timeout)
	add_child(_idle_timer)

func _enter():
	owner_node.velocity = Vector2.ZERO
	# Randomizar tempo de idle e iniciar timer
	_randomize_idle_time() 
	_idle_timer.start()

func _exit():
	_idle_timer.stop()

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player < owner_node.chase_range_sqr:
			transition_to("Chase")
			return

func _physics_update(_delta: float):
	pass

func _randomize_idle_time():
	_idle_timer.wait_time = randf_range(1, 2)

func _on_idle_timer_timeout() -> void:
	transition_to("Patrol")
	return
