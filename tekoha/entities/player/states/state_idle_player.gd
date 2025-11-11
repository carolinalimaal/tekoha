class_name IdleStatePlayer 
extends State

func _enter() -> void:
	owner_node.velocity = Vector2.ZERO
	# Atualizar variavel que controla animacoes
	owner_node.anim_transition = 0

func _exit() -> void:
	pass

func _update(_delta: float) -> void:
	# Verificar se ha  input de entrada, se sim transiciona para WALK
	var direction : Vector2 = owner_node.get_direction()
	if direction:
		transition_to("walk")
		return
	# TODO: isso sera arrumado depois 
	owner_node.check_roll_input()
	owner_node.check_attack_input()

func _physics_update(_delta: float) -> void:
	pass
