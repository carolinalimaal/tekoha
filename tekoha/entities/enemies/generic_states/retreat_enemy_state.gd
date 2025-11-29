class_name RetreatEnemyState 
extends State

var _distance_to_player: float
var _direction_to_player: Vector2

func _enter():
	pass

func _exit():
	pass

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player > owner_node.retreat_range_sqr:
			transition_to("circling")
			return

func _physics_update(_delta: float):
	if GlobalRefs.player:
		# Atualizar facing_direction, move_irection e velocidade
		_direction_to_player = owner_node.get_direction_to_player()
		owner_node.facing_direction = _direction_to_player
		owner_node.move_direction = - _direction_to_player
		owner_node.velocity = owner_node.move_direction * (owner_node.chase_speed * 0.8)
