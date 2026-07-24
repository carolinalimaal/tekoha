class_name Animals extends Node2D

@onready var room: Level = $".."
@export var arara_scene: PackedScene
@export var blue_arara_sprite: SpriteFrames
@export var red_arara_sprite: SpriteFrames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.current_save.game_state == GameManager.GameState.AFTER_PUZZLE_3:
		print("ninguem nasce")
		for animal in self.get_children():
			animal.visible = false
	else:
		start_araras_routine()

func start_araras_routine():
	while true:
		var random_numb = randi_range(5,10)
		await get_tree().create_timer(random_numb).timeout
	
		var random_arara = randi_range(0,1)
		match random_arara:
			0:
				arara_instatiation(blue_arara_sprite)
			1:
				arara_instatiation(red_arara_sprite)

func arara_instatiation(sprite: SpriteFrames):
	var arara = arara_scene.instantiate()
	arara.z_index = 10
	arara.animated_frames = sprite
	arara.flyer = true
	arara.direction = [-1,1].pick_random()
	arara.flipped = arara.direction < 0
	
	if GlobalRefs.player:
		if arara.flipped:
			arara.global_position.x = room.limit_right
			arara.global_position.y = GlobalRefs.player.global_position.y - 40
			arara.room_limit_left = room.limit_left
		else:
			arara.global_position.x = room.limit_left
			arara.global_position.y = GlobalRefs.player.global_position.y - 40
			arara.room_limit_right = room.limit_right
	
	self.add_child(arara)
