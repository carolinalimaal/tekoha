class_name LungeEnemyState 
extends State

var _distance_to_player: float
var direction_to_player: Vector2

func _enter():
	pass

func _exit():
	pass

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player <= owner_node.attack_range_sqr:
			transition_to("attack")
			return
	pass

func _physics_update(_delta: float):
	if GlobalRefs.player:
		# Atualizar facing_direction, move_irection e velocidade
		owner_node.move_direction = owner_node.get_direction_to_player()
		owner_node.velocity = owner_node.move_direction * owner_node.attack_speed
		
		owner_node.facing_direction = owner_node.move_direction
