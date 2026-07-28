extends Area2D

@export var enemy_scene: PackedScene

var crab_spawn_timer: Timer
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
	crab_spawn_timer = Timer.new()
	crab_spawn_timer.one_shot = false
	crab_spawn_timer.autostart = true
	add_child(crab_spawn_timer)
	crab_spawn_timer.timeout.connect(_on_crab_spawn_timer_timeout)
	
	crab_spawn_timer.set_wait_time(randf_range(1.0, 3.0))

func _on_crab_spawn_timer_timeout():
	spawn_enemy()
	crab_spawn_timer.set_wait_time(randf_range(1.0, 3.0))

func spawn_enemy() -> void:
	if not enemy_scene:
		return
		
	var enemy = enemy_scene.instantiate()
	enemy.global_position = get_random_position_in_area()
	get_parent().get_parent().add_child(enemy)

func get_random_position_in_area() -> Vector2:
	var polygon = collision_polygon_2d.polygon
	if polygon.size() < 3:
		return global_position 

	var min_x = polygon[0].x
	var max_x = polygon[0].x
	var min_y = polygon[0].y
	var max_y = polygon[0].y

	for point in polygon:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)

	var max_attempts = 100
	for i in range(max_attempts):
		var local_point = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)

		if Geometry2D.is_point_in_polygon(local_point, polygon):
			return collision_polygon_2d.to_global(local_point)

	return global_position
