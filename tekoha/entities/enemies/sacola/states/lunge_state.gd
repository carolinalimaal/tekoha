extends State

@export var _lunge_duration: float = 0.2

var _lunge_timer: Timer
var direction_to_player: Vector2

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_lunge_timer = Timer.new()
	_lunge_timer.one_shot = true
	_lunge_timer.autostart = false
	_lunge_timer.timeout.connect(_on_lunge_timer_timeout)
	add_child(_lunge_timer)

func _enter():
	_lunge_timer.wait_time = _lunge_duration
	_lunge_timer.start()

func _exit():
	_lunge_timer.stop()
	pass

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	if GlobalRefs.player:
		# Atualizar facing_direction, move_direction e velocidade
		owner_node.move_direction = owner_node.get_direction_to_player()
		owner_node.velocity = owner_node.move_direction * owner_node.attack_speed
		
		owner_node.facing_direction = owner_node.move_direction

func _on_lunge_timer_timeout() -> void:
	transition_to("Attack")
	return
