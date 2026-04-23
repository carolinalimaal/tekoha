extends HBoxContainer

const HEART_SIZE: int = 4

@export var heart_icon: PackedScene

func update_hearts(current_health: int, max_health: int = -1) -> void:
	for child in get_children():
		child.queue_free()
	var total_value = max_health if max_health > 0 else current_health
	var total_hearts = ceil(total_value / float(HEART_SIZE))
	
	for i in range(total_hearts):
		var heart_instance = heart_icon.instantiate()
		add_child(heart_instance)
		var heart_value = clampi(current_health, 0, HEART_SIZE)
		heart_instance.update_sprite(heart_value)
		current_health -= HEART_SIZE
