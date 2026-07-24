extends Area2D

@export var enemy_scene: PackedScene


var crab_spawn_timer: Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	crab_spawn_timer = Timer.new()
	crab_spawn_timer.one_shot = false
	crab_spawn_timer.autostart = true
	add_child(crab_spawn_timer)
	crab_spawn_timer.timeout.connect(_on_crab_spawn_timer_timeout)

func _on_crab_spawn_timer_timeout():
	spawn_enemy()
	crab_spawn_timer.set_wait_time(randi_range(1, 3)) 

func spawn_enemy() -> void:
	if not enemy_scene:
		return
		
	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = get_random_position_in_area()
	get_parent().get_parent().add_child(enemy)

func get_random_position_in_area() -> Vector2:
	var shape = collision_shape_2d.shape
	
	if shape is RectangleShape2D:
		
		var size = shape.size / 2
		
		var random_x = randf_range(-size.x, size.x)
		var random_y = randf_range(-size.y, size.y)
		
		# Aplica a rotação e a escala global da própria Area2D
		return global_position + Vector2(random_x, random_y)
		
	return global_position
