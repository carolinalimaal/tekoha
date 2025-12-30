class_name StunState
extends State

var _attack_data : AttackData

func _enter() -> void:
	# Aplicar knockback
	var knockback_direction: Vector2 = -(_attack_data.attack_direction - owner_node.global_position).normalized()
	owner_node.velocity = knockback_direction * _attack_data.knockback_force
	owner_node.facing_direction = - knockback_direction
	# Desabilitar a hitbox_collision
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	
	# Conectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.connect(_on_animation_finished)

func _exit() -> void:
	# Desabilitar a hitbox_collision
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", false)
	
	# Disconectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_finished)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func receive_attack_data(attack_data: AttackData):
	_attack_data = attack_data

func _on_animation_finished(anim_name: StringName) -> void:
	# No fim da animacao de morte, chama o metodo die()
	if anim_name in ["stun_down", "stun_up", "stun_left", "stun_right"]:
		transition_to("Idle")
		return
