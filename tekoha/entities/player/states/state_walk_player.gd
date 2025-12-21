class_name WalkStatePlayer 
extends State

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(_delta: float) -> void:
	# Verificar se ha input de entrada, se nao transiciona para IDLE
	var direction : Vector2 = owner_node.get_direction()
	if not direction:
		transition_to("Idle")
		return
	
	# Atualizar o move_direction e facing_direction
	owner_node.move_direction = direction
	owner_node.facing_direction = owner_node.move_direction

func _physics_update(_delta: float) -> void:
	# Aplicar o movimento
	owner_node.velocity = owner_node.move_direction * owner_node.SPEED
