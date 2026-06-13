extends State

@export var max_charge_duration: float = 2.0

var _max_charge_timer: Timer

func _ready():
	_max_charge_timer = Timer.new()
	_max_charge_timer.one_shot = true
	_max_charge_timer.timeout.connect(_on_max_charge_timer_timeout)
	add_child(_max_charge_timer)

func _enter():
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", false)
	owner_node.hurtbox_component.area_entered.connect(_on_hit_player)
	_max_charge_timer.wait_time = max_charge_duration
	_max_charge_timer.start()

func _exit():
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	if owner_node.hurtbox_component.area_entered.is_connected(_on_hit_player):
		owner_node.hurtbox_component.area_entered.disconnect(_on_hit_player)
	_max_charge_timer.stop()

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	if not GlobalRefs.player:
		owner_node.velocity = Vector2.ZERO
		return
	var x_diff = GlobalRefs.player.global_position.x - owner_node.global_position.x
	owner_node.move_direction = Vector2(sign(x_diff), 0.0)
	owner_node.facing_direction = owner_node.move_direction
	owner_node.velocity = owner_node.move_direction * owner_node.attack_speed

func _on_hit_player(_area: Area2D):
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	owner_node.state_machine.set_process(false)
	owner_node.set_physics_process(false)
	owner_node.die()

func _on_max_charge_timer_timeout():
	transition_to("Align")
