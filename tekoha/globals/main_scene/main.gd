extends Node2D

@onready var level_container: Node2D = $Level

func _ready() -> void:
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
