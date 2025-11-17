class_name AttackEnd
extends State

func _enter() -> void:
	# Conectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.connect(_on_animation_finished)
	# Atualizar variavel que controla animacoes
	owner_node.anim_transition = 4

func _exit() -> void:
	# Desconectar o sinal de animation_finished (evitar conflito com outros estados)
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_finished)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["attack_end_down", "attack_end_left", "attack_end_right", "attack_end_up"]:
		transition_to("idle")
		return
