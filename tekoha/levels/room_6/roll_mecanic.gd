extends Node2D

@onready var static_body: StaticBody2D = $StaticBody2D
@onready var sprite: Sprite2D = $StaticBody2D/Sprite2D
var collision_deactivated: bool = false
var enabled: bool = true

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false
	if collision_deactivated:
		static_body.set_collision_layer_value(9, true)
		collision_deactivated = false
		sprite.z_index = 0

func _on_roll_area_body_entered(body: Node2D) -> void:
	if not enabled:
		return
	if body is Player and body.state_machine.current_state.name == "Roll":
		static_body.set_collision_layer_value(9, false)
		collision_deactivated = true
		sprite.z_index = 2

func _on_roll_area_body_exited(body: Node2D) -> void:
	if not enabled:
		return
	if body is Player and collision_deactivated:
		static_body.set_collision_layer_value(9, true)
		collision_deactivated = false
		sprite.z_index = 0
