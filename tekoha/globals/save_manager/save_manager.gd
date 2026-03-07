extends Node

const SAVE_PATH: String = "user://tekoha_save.tres"

func save_game(save_data: SaveData) -> void:
	ResourceSaver.save(save_data, SAVE_PATH)

func load_game() -> SaveData:
	if FileAccess.file_exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveData
	return null
