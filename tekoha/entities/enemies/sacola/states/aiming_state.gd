extends State

var _distance_to_player: float

func _enter():
	owner_node.velocity = Vector2.ZERO
	pass

func _exit():
	pass

func _update(_delta: float):
	if GlobalRefs.player:
		# Verificar distância do jogador
		_distance_to_player = owner_node.get_distance_sqr_to_player()
		if _distance_to_player > owner_node.attack_range_sqr:
			transition_to("Chase")
			return
		if owner_node.can_attack and owner_node.is_attack_allowed():
			transition_to("Lunge")
			return

func _physics_update(_delta: float):
	pass
