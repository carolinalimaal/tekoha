class_name CirclingEnemyState 
extends State

var _circling_timer: Timer
var _circle_direction: int = 1
var _distance_to_player: float

@export var ATTACK_CHANCE: float = 0.65

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_circling_timer = Timer.new()
	_circling_timer.one_shot = true
	_circling_timer.timeout.connect(_on_circling_timer_timeout)
	add_child(_circling_timer)

func _enter():
	# Escolher uma direção para rodear
	_circle_direction = [-1,1].pick_random()
	# Randomizar tempo rodeando e iniciar o timer
	_circling_timer.wait_time = randf_range(1.0, 2.0)
	_circling_timer.start()

func _exit():
	_circling_timer.stop()

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player > owner_node.circling_range_sqr:
			transition_to("Chase")
			return
		if _distance_to_player < owner_node.retreat_range_sqr:
			transition_to("Retreat")
			return

func _physics_update(_delta: float):
	if GlobalRefs.player:
		# Calcular movimento em círculo
		var vector_player_to_enemy = owner_node.global_position - GlobalRefs.player.global_position
		var orbit_vector = vector_player_to_enemy.rotated(0.25 * _circle_direction)
		var target_orbit_position = GlobalRefs.player.global_position + orbit_vector.normalized() * owner_node.circling_range
		var direction_to_target = (target_orbit_position - owner_node.global_position).normalized()
		
		# Atualizar facing_direction, move_irection e velocidade
		owner_node.facing_direction = owner_node.get_direction_to_player()
		owner_node.move_direction = direction_to_target
		owner_node.velocity = owner_node.move_direction * owner_node.patrol_speed

func _on_circling_timer_timeout() -> void:
	# Decisão da próxima ação
	var chance = randf()
	if owner_node.can_attack() and chance < ATTACK_CHANCE:
		if state_machine.states.has("lunge"):
			transition_to("Lunge")
			return
		transition_to("Attack")
		return
	else:
		transition_to("Pausing")
		return
