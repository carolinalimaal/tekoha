class_name Attack2StatePlayer 
extends State

const ATTACK_SPEED : int = 75
const ATTACK_KNOCKBACK : int = 25
const ATTACK_DAMAGE : int = 6
const ANIM_DURATION : float = 0.4

var _timeout_timer : SceneTreeTimer

func _enter() -> void:
	owner_node.velocity = Vector2.ZERO
	# Pegar a direcao do ataque
	var attack_direction = owner_node.get_aim_direction()
	owner_node.attack_direction = attack_direction if attack_direction != Vector2.ZERO else owner_node.facing_direction
	# Alterar os valores do ataque
	owner_node.hurtbox_component.attack_data.damage_value = ATTACK_DAMAGE
	owner_node.hurtbox_component.attack_data.knockback_force= ATTACK_KNOCKBACK
	# Conectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.connect(_on_animation_finished)
	
	# Timer de seguranca caso o AnimationTree nao emita o sinal animation_finished
	_timeout_timer = get_tree().create_timer(ANIM_DURATION)
	_timeout_timer.timeout.connect(_on_timeout)

func _exit() -> void:
	# Desconectar o sinal de animation_finished (evitar conflito com outros estados)
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_finished)
	if _timeout_timer:
		_timeout_timer.timeout.disconnect(_on_timeout)
		_timeout_timer = null
	owner_node.velocity = Vector2.ZERO
	# Atualizar a facing_direction
	owner_node.facing_direction = owner_node.attack_direction
	# Desabilitar a hurtbox_collision
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", true)



func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func attack():
	owner_node.velocity = owner_node.attack_direction * ATTACK_SPEED
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", false)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["attack_2_down", "attack_2_left", "attack_2_right", "attack_2_up"]:
		transition_to("Idle")
		return

func _on_timeout() -> void:
	if state_machine.current_state == self:
		transition_to("Idle")
