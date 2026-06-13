extends State

var _cooldown_timer: Timer

func _ready():
	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	_cooldown_timer.timeout.connect(_on_cooldown_timeout)
	add_child(_cooldown_timer)

func _enter():
	owner_node.velocity = Vector2.ZERO
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", false)
	_cooldown_timer.wait_time = 0.2
	_cooldown_timer.start()

func _exit():
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", true)

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	pass

func _on_cooldown_timeout():
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	owner_node.state_machine.set_process(false)
	owner_node.set_physics_process(false)
	owner_node.die()
