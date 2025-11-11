class_name PlayerCamera extends Camera2D

var target_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	make_current()

func _process(delta: float) -> void:
	get_target()
	global_position = global_position.lerp(target_position, 1 - exp(-delta * 5))

func get_target():
	var player : Player = get_tree().get_first_node_in_group("player")
	if player:
		target_position = player.global_position
