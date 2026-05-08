class_name PlayerCamera extends Camera2D

var level: Level
var target_position : Vector2 = Vector2.ZERO
var can_follow_player: bool = true

var random_strengh: float = 25.0
var shake_fade: float = 4
var shake_strengh: float

func _ready() -> void:
	level = get_parent()
	if level is Level:
		limit_left = level.limit_left
		limit_right = level.limit_right
		limit_bottom = level.limit_bottom
		limit_top = level.limit_top
	var root_mecanic: RootMecanic = level.get_node_or_null("RootMecanic")
	if root_mecanic:
		print("root mecanic")
		root_mecanic.shake_camera.connect(_on_camera_shake)
	else:
		print(root_mecanic)
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
	print("can_camera_shake")
	apply_shake()
