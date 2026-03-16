extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var level = get_parent()
	#var level_parent = level.get_parent()
	#
	#var player_node = level_parent.get_child(1)
	#var camera: PlayerCamera = player_node.get_child(1)
	
	#var camera: Camrea2D = GlobalRefs.camera (ideia)
	
	#camera.limit_bottom = -500
	#camera.limit_top = 500
	#camera.limit_left = 0
	#camera.limit_right = 0

	# script pra pegar o ponto central do tilemap
	#var tilemap: TileMapLayer = $Tiles/HouseFloor
	#
	#var rect = tilemap.get_used_rect()
	#var tile_size = tilemap.tile_set.tile_size
	#
	#var size_pixels = rect.size * tile_size
	#var pos_pixels = rect.position * tile_size
	#
	#var center_local = pos_pixels + size_pixels / 2
	#var center_global = tilemap.to_global(center_local)
#
	#print(center_global)
	
	#var camera: PlayerCamera = $Player/PlayerCamera
	
	#set_limits_camera(camera)
	pass

func set_limits_camera(camera: PlayerCamera) -> void:
	camera.limit_bottom = 363
	camera.limit_top = -75
	camera.limit_right = 539
	camera.limit_left = -140
