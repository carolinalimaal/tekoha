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
	if GlobalRefs.player and GlobalRefs.player.health_component:
		GameManager.current_save.player_health = GlobalRefs.player.health_component.current_health
