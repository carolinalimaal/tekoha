class_name PlayerCamera extends Camera2D

var level: Level
var target_position : Vector2 = Vector2.ZERO
var can_follow_player: bool = true

var random_strengh: float = 25.0
var shake_fade: float = 4
var shake_strengh: float

func _ready() -> void:
	GlobalRefs.player_camera = self
	level = get_parent().get_node("Level").get_child(0)
	update_camera_stats(level)
	
	make_current()

func _process(delta: float) -> void:
	if can_follow_player:
		get_target()
		global_position = global_position.lerp(target_position, 1 - exp(-delta * 5))
	# vai atualizando o camera shake até chegar em 0, no caso dura cerca de 1s
	if shake_strengh > 0:
		shake_strengh = lerpf(shake_strengh, 0, shake_fade * delta)
		offset = random_offset()
		if shake_strengh < 0.1:
			shake_strengh = 0

func get_target():
	var player : Player = get_tree().get_first_node_in_group("player")
	if player:
		target_position = player.global_position

func random_offset():
	# faz a camera vibrar aleatoriamente alguns pixels em Vec2
	return Vector2(randf_range(-shake_strengh,shake_strengh), randf_range(-shake_strengh,shake_strengh))

func apply_shake():
	shake_strengh = random_strengh

func _on_camera_shake():
	if InputManager.active_input_source == InputManager.InputSource.CONTROLLER:
		Input.start_joy_vibration(0, 0.5, 0.5, 0.6)
	apply_shake()
	
func update_camera_stats(level: Level):
	if level is Level:
		limit_left = level.limit_left
		limit_right = level.limit_right
		limit_bottom = level.limit_bottom
		limit_top = level.limit_top
		
		zoom.x = level.camera_zoom
		zoom.y = level.camera_zoom
		
	var root_mecanic: RootMecanic = level.get_node_or_null("RootMecanic")
	if root_mecanic:
		root_mecanic.shake_camera.connect(_on_camera_shake)
