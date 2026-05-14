class_name RootMecanic extends Node2D

signal shake_camera()

#@onready var torche_one: Torch = $Torches/Torche
#@onready var torche_two: Torch = $Torches/Torche2
#@onready var torche_three: Torch = $Torches/Torche3
#@onready var root: Root = $Root
#@onready var root_two: Root = $Root2
#@onready var root_three: Root = $Root3
#@onready var root_four: Root = $Root4
#@onready var root_five: Root = $Root5
#@onready var root_six: Root = $Root6
@onready var mecanic_activators: Node2D = $MecanicActivators
@onready var roots: Node2D = $Roots
@onready var roots_marker: Marker2D = $RootsMarkerPos

@export var meta_activations: int
var current_activations: int = 0

@export var has_consumable: bool
var consumable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#torche_one.torch_turnned_off.connect(_on_torch_turned_off)
	#torche_two.torch_turnned_off.connect(_on_torch_turned_off)
	#torche_three.torch_turnned_off.connect(_on_torch_turned_off)
	if has_consumable:
		consumable = get_node("Bau") as Bau
		turn_consumable_off()
	
	for activator in mecanic_activators.get_children():
		activator.puzzle_activator.connect(_on_puzzle_activator_off)

func _on_puzzle_activator_off():
	current_activations+=1
	if current_activations in [1, (meta_activations/2) + 1, meta_activations]:
		shake_camera.emit()
		await get_tree().create_timer(1).timeout
		camera_zoom_in_roots()
	

func camera_zoom_in_roots():
	get_tree().paused = true
	var camera: PlayerCamera = get_parent().get_node("PlayerCamera")
	if camera:
		camera_anim(camera)

func camera_anim(camera: PlayerCamera):
	camera.can_follow_player = false
	var roots_marker_pos: Vector2 = roots_marker.global_position
	var tween_zoom_in = create_tween()

	tween_zoom_in.parallel().tween_property(camera,"position",roots_marker_pos,1.2)
	tween_zoom_in.parallel().tween_property(camera,"zoom",Vector2(2, 2),1.2)
	await tween_zoom_in.finished

	root_anim()
	await get_tree().create_timer(1.2).timeout

	# volta da câmera
	var tween_zoom_out = create_tween()
	tween_zoom_out.parallel().tween_property(camera,"position",GlobalRefs.player.global_position,1.2)
	tween_zoom_out.parallel().tween_property(camera,"zoom",Vector2(1.5, 1.5),1.2)
	await tween_zoom_out.finished

	camera.can_follow_player = true
	get_tree().paused = false

func root_anim():
	var middle_step = (meta_activations/2) + 1
	print("aqui",middle_step)
	match current_activations:
		1:
			var root: Root = roots.get_child(0)
			root.root_remove()
			
		middle_step:
			var root: Root = roots.get_child(1)
			root.root_remove()
			
		meta_activations:
			for i in range(2, len(roots.get_children())):
				print(i)
				var root: Root = roots.get_child(i)
				root.root_remove()
			
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
