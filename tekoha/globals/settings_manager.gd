extends Node
# Autoload Global para gerenciar e persistir as configurações de vídeo e áudio.

const SETTINGS_PATH: String = "user://settings.cfg"

var fullscreen: bool = false
var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

func _ready() -> void:
	_load_settings()
	_apply_volume("Master", master_volume)
	_apply_volume("Music", music_volume)
	_apply_volume("SFX", sfx_volume)

func set_fullscreen(value: bool) -> void:
	fullscreen = value
	_apply_fullscreen()
	_save_settings()

func set_master_volume(value: float) -> void:
	master_volume = value
	_apply_volume("Master", value)
	_save_settings()

func set_music_volume(value: float) -> void:
	music_volume = value
	_apply_volume("Music", value)
	_save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	_apply_volume("SFX", value)
	_save_settings()

func _apply_fullscreen() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED
	)

func _apply_volume(bus_name: String, value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value <= 0.0)

func _is_fullscreen() -> bool:
	var mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	return mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN

func _load_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		fullscreen = config.get_value("video", "fullscreen", _is_fullscreen())
		master_volume = config.get_value("audio", "master_volume", 1.0)
		music_volume = config.get_value("audio", "music_volume", 1.0)
		sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
		_apply_fullscreen()
	else:
		# Primeira execução: respeita o modo de janela definido no projeto.
		fullscreen = _is_fullscreen()

func _save_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("video", "fullscreen", fullscreen)
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save(SETTINGS_PATH)