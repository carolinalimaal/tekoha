class_name RootMecanic extends Node2D

signal shake_camera()
signal puzzle_completed

@onready var mecanic_activators: Node2D = $MecanicActivators
@onready var roots: Node2D = $Roots
@onready var roots_marker: Marker2D = $RootsMarkerPos

@export var meta_activations: int
var current_activations: int = 0

var level_parent: Level

@export var has_consumable: bool
var consumable

var enemies: Node2D

func _ready() -> void:
	level_parent = get_parent()	
	enemies = get_parent().get_node_or_null("Enemies")
	
	if has_consumable:
		consumable = get_node("Bau") as Bau
		turn_consumable_off()
	
	for activator in mecanic_activators.get_children():
		activator.puzzle_activator.connect(_on_puzzle_activator_off)

func _on_puzzle_activator_off():
	current_activations += 1
	var step = current_activations
	
	if level_parent.name == "Room10":
		if current_activations in [1, meta_activations / 2 + 1, meta_activations]:
			shake_camera.emit()
			await get_tree().create_timer(1).timeout
			camera_zoom_in_roots(step)
	else:
		if current_activations == meta_activations:
			shake_camera.emit()
			await get_tree().create_timer(1).timeout
			camera_zoom_in_roots(step)

func camera_zoom_in_roots(step: int):
	partial_pause()
	camera_anim(GlobalRefs.player_camera, step)

func camera_anim(camera: PlayerCamera, step: int):
	camera.can_follow_player = false
	var roots_marker_pos: Vector2 = roots_marker.global_position
	var tween_zoom_in = create_tween()

	tween_zoom_in.parallel().tween_property(camera,"position",roots_marker_pos,1.2)
	tween_zoom_in.parallel().tween_property(camera,"zoom",Vector2(2, 2),1.2)
	await tween_zoom_in.finished

	root_anim(step)
	await get_tree().create_timer(1.2).timeout

	# volta da câmera
	var tween_zoom_out = create_tween()
	tween_zoom_out.parallel().tween_property(camera,"position",GlobalRefs.player.global_position,1.2)
	tween_zoom_out.parallel().tween_property(camera,"zoom",Vector2(1.5, 1.5),1.2)
	await tween_zoom_out.finished

	camera.can_follow_player = true
	partial_despause()
	if step == meta_activations:
		puzzle_completed.emit()

func root_anim(step: int):
	var middle_step: int = meta_activations / 2 + 1
	if level_parent.name == "Room10":
		if step == 1:
			roots.get_child(0).root_remove()
		elif step == middle_step:
			roots.get_child(1).root_remove()
		elif step == meta_activations:
			for i in range(2, roots.get_child_count()):
				roots.get_child(i).root_remove()
			if has_consumable:
				turn_consumable_on()
	else:
		for root in roots.get_children():
			root.root_remove()
		if has_consumable:
			turn_consumable_on()

func set_completed() -> void:
	for activator in mecanic_activators.get_children():
		if activator is Torch:
			activator.hitbox_component.monitoring = false
			activator.hitbox_collision.disabled = true
		if activator.puzzle_activator.is_connected(_on_puzzle_activator_off):
			activator.puzzle_activator.disconnect(_on_puzzle_activator_off)

	for root in roots.get_children():
		root.hide()
		root.set_collision_layer_value(9, false)

	if has_consumable:
		turn_consumable_on()

func turn_consumable_on():
	consumable.visible = true
	consumable.interactable_component.set_deferred("monitoring", true)
	
	var consumable_colision = consumable.get_node("CollisionShape2D")
	consumable_colision.set_deferred("disabled", false)

func turn_consumable_off():
	consumable.visible = false
	consumable.interactable_component.set_deferred("monitoring", false)
	
	var consumable_colision = consumable.get_node("CollisionShape2D")
	consumable_colision.set_deferred("disabled", true)

func partial_pause():
	GlobalRefs.player.can_move = false
	UIManager.is_interact_ui_open = true
	mecanic_activators.process_mode = Node.PROCESS_MODE_DISABLED
	if enemies != null:
		enemies.process_mode = Node.PROCESS_MODE_DISABLED

func partial_despause():
	GlobalRefs.player.can_move = true
	UIManager.is_interact_ui_open = false
	mecanic_activators.process_mode = Node.PROCESS_MODE_INHERIT
	if enemies != null:
		enemies.process_mode = Node.PROCESS_MODE_INHERIT
