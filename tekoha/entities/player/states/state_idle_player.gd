class_name IdleStatePlayer 
extends State

func _enter() -> void:
	owner_node.velocity = Vector2.ZERO

func _exit() -> void:
	pass

func _update(_delta: float) -> void:
	# Verificar se ha  input de entrada, se sim transiciona para WALK
	var direction : Vector2 = owner_node.get_direction()
	if direction:
		transition_to("Walk")
		return

func _physics_update(_delta: float) -> void:
	pass
