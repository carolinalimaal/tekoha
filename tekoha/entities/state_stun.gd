class_name StunState
extends State

const ANIM_DURATION : float = 0.55 

var _attack_data : AttackData
var _timeout_timer : SceneTreeTimer

func _enter() -> void:
	# Aplicar knockback
	var knockback_direction: Vector2 = -(_attack_data.attack_direction - owner_node.global_position).normalized()
	owner_node.velocity = knockback_direction * _attack_data.knockback_force
	owner_node.facing_direction = - knockback_direction
	# Conectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.connect(_on_animation_finished)
	# Failsafe: garante que o estado nao fique travado caso animation_finished nao dispare
	_timeout_timer = get_tree().create_timer(ANIM_DURATION)
	_timeout_timer.timeout.connect(_on_timeout)

func _exit() -> void:
	# Disconectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_finished)
	if _timeout_timer:
		_timeout_timer.timeout.disconnect(_on_timeout)
		_timeout_timer = null

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func receive_attack_data(attack_data: AttackData):
	_attack_data = attack_data

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["stun_down", "stun_up", "stun_left", "stun_right"]:
		transition_to("Idle")
		return

func _on_timeout() -> void:
	if state_machine.current_state == self:
		transition_to("Idle")
