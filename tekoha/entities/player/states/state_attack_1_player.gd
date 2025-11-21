class_name Attack1StatePlayer 
extends State

const ATTACK_SPEED : int = 50
const ATTACK_DAMAGE : int = 15
const ATTACK_KNOCKBACK : int = 20
const STUN_DURATION : float = 0.5

func _enter() -> void:
	owner_node.velocity = Vector2.ZERO
	# Pegar a direcao do ataque
	var attack_direction = owner_node.get_aim_direction()
	owner_node.attack_direction = attack_direction if attack_direction != Vector2.ZERO else owner_node.facing_direction
	# Alterar os valores do ataque
	owner_node.hurtbox_component.attack_data.damage_value = ATTACK_DAMAGE
	owner_node.hurtbox_component.attack_data.knockback_force= ATTACK_KNOCKBACK
	owner_node.hurtbox_component.attack_data.stun_duration = STUN_DURATION
	# Conectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.connect(_on_animation_finished)
	# Atualizar variavel que controla animacoes
	owner_node.anim_transition = 3

func _exit() -> void:
	owner_node.velocity = Vector2.ZERO
	# Atualizar a facing_direction
	owner_node.facing_direction = owner_node.attack_direction
	# Desabilitar a hurtbox_collision
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	# Desconectar o sinal de animation_finished (evitar conflito com outros estados)
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_finished)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func attack():
	owner_node.velocity = owner_node.attack_direction * ATTACK_SPEED
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", false)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["attack_1_down", "attack_1_left", "attack_1_right", "attack_1_up"]:
		transition_to("attackend")
		return
