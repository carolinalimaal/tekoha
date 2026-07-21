extends State

func _enter() -> void:
	owner_node.velocity = Vector2.ZERO
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	owner_node.collision_shape.set_deferred("disabled", true)
	owner_node.sprite_2d.visible = false
	owner_node.spawn_sprite.visible = true
	owner_node.spawn_sprite.play("spawn")
	owner_node.spawn_sprite.animation_finished.connect(_on_spawn_finished, CONNECT_ONE_SHOT)

func _exit() -> void:
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", false)
	owner_node.collision_shape.set_deferred("disabled", false)

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func _on_spawn_finished() -> void:
	owner_node.spawn_sprite.visible = false
	owner_node.sprite_2d.visible = true
	transition_to("Align")
