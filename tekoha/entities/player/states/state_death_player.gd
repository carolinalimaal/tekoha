class_name DeathStatePlayer
extends State

func _enter() -> void:
	owner_node.velocity = Vector2.ZERO
	# Desabilitar a hitbox_collision
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	# Conectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.connect(_on_animation_finished)
	# Atualizar variavel que controla animacoes
	owner_node.anim_transition = 7

func _exit() -> void:
	# Disconectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_finished)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func _on_animation_finished(anim_name: StringName) -> void:
	# No fim da animacao de morte, chama o metodo die()
	if anim_name in ["death_down", "death_up", "death_left", "death_right"]:
		owner_node.die()
