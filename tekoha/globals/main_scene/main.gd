extends Node2D

@onready var level_container: Node2D = $Level
@onready var afternoon_filter: DirectionalLight2D = $AfternoonFilter
@onready var night_fall_filter: DirectionalLight2D = $NightFallFilter

func _ready() -> void:
	GlobalRefs.game_afternoon_filter = afternoon_filter
	GlobalRefs.game_nightfall_filter = night_fall_filter
	if GameManager.current_save:
		_setup_world_from_save()

func _setup_world_from_save() -> void:
	var save = GameManager.current_save
	
	if save.current_level_path != "":
		var current_level = level_container.get_child(0) if level_container.get_child_count() > 0 else null
		
		if current_level == null or current_level.scene_file_path != save.current_level_path:
			if current_level:
				current_level.queue_free()
			
			var new_level_scene = load(save.current_level_path)
			if new_level_scene:
				var new_level_instance = new_level_scene.instantiate()
				level_container.add_child(new_level_instance)
				GlobalRefs.player_camera.update_camera_stats(new_level_instance)
			
	
	if save.player_position != Vector2.ZERO:
		GlobalRefs.player.set_deferred("global_position", save.player_position)
		GlobalRefs.player_camera.set_deferred("global_position", save.camera_pos)
	
	if GameManager.current_save.game_state >= GameManager.GameState.PRE_BOSSFIGHT:
		GlobalRefs.game_afternoon_filter.hide()
		GlobalRefs.game_nightfall_filter.hide()
	elif GameManager.current_save.game_state >= GameManager.GameState.IN_ROOM_8:
		GlobalRefs.game_afternoon_filter.show()
		if GameManager.current_save.game_state >= GameManager.GameState.AFTER_PUZZLE_3:
			GlobalRefs.game_nightfall_filter.show()
