class_name WalkStatePlayer 
extends State

func _enter() -> void:
	# Atualizar variavel que controla animacoes
	owner_node.anim_transition = 1

func _exit() -> void:
	pass

func _update(_delta: float) -> void:
	# Verificar se ha input de entrada, se nao transiciona para IDLE
	var direction : Vector2 = owner_node.get_direction()
	if not direction:
		transition_to("idle")
		return
	
	# Atualizar o move_direction e facing_direction
	owner_node.move_direction = direction
	owner_node.facing_direction = owner_node.move_direction
	# TODO: isso sera arrumado depois 
	owner_node.check_roll_input()
	owner_node.check_attack_input()

func _physics_update(_delta: float) -> void:
	# Aplicar o movimento
	owner_node.velocity = owner_node.move_direction * owner_node.SPEED
