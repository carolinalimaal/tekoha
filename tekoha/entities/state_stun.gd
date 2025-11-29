class_name StunState
extends State

var _attack_data : AttackData
var _stun_timer : Timer

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_stun_timer = Timer.new()
	_stun_timer.one_shot = true
	_stun_timer.autostart = false
	_stun_timer.timeout.connect(_on_stun_timer_timeout)
	add_child(_stun_timer)

func _enter() -> void:
	# Aplicar knockback
	var knockback_direction = -(_attack_data.attack_direction - owner_node.global_position).normalized()
	owner_node.velocity = knockback_direction * _attack_data.knockback_force
	# Desabilitar a hitbox_collision
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	# Atribuir o tempo de stun
	_stun_timer.wait_time = _attack_data.stun_duration
	# Iniciar o timer
	_stun_timer.start()

func _exit() -> void:
	# Desabilitar a hitbox_collision
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", false)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func receive_attack_data(attack_data: AttackData):
	_attack_data = attack_data

func _on_stun_timer_timeout() -> void:
	transition_to("idle")
	return
