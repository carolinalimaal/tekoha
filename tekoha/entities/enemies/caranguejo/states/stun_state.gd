extends State

var _attack_data: AttackData
var _stun_timer: Timer

func _ready():
	_stun_timer = Timer.new()
	_stun_timer.one_shot = true
	_stun_timer.timeout.connect(_on_stun_timeout)
	add_child(_stun_timer)

func receive_attack_data(attack_data: AttackData):
	_attack_data = attack_data

func _enter():
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	var knockback_dir = -((_attack_data.attack_direction - owner_node.global_position).normalized())
	owner_node.velocity = knockback_dir * _attack_data.knockback_force
	_stun_timer.wait_time = 0.3
	_stun_timer.start()

func _exit():
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", false)

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	pass

func _on_stun_timeout():
	if not is_instance_valid(owner_node) or owner_node.is_dead:
		return
	transition_to("Align")
