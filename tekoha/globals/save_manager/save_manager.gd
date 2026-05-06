extends Node

const SAVE_PATH: String = "user://tekoha_save.tres"

func save_game(save_data: SaveData) -> void:
	_update_data()
	ResourceSaver.save(save_data, SAVE_PATH)

func load_game() -> SaveData:
	if FileAccess.file_exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveData
	return null

func _update_data() -> void:
	if GlobalRefs.player:
		if GlobalRefs.player.health_component:
			GameManager.current_save.player_health = GlobalRefs.player.health_component.current_health
		GameManager.current_save.player_position = GlobalRefs.player.global_position
		GameManager.current_save.camera_pos = GlobalRefs.player.global_position
	
	var main_node = get_tree().root.find_child("Main", true, false)
	if main_node:
		var level_container = main_node.get_node("Level")
		if level_container.get_child_count() > 0: 
			var current_level = level_container.get_child(0)
			GameManager.current_save.current_level_path = current_level.scene_file_path
