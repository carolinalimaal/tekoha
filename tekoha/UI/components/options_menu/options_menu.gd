class_name OptionsMenu
extends Control

signal closed

@onready var fullscreen_toggle: Button = $Background/CenterContainer/PanelContainer/MarginContainer/Content/FullscreenRow/FullscreenToggle
@onready var fullscreen_fire: TextureRect = $Background/CenterContainer/PanelContainer/MarginContainer/Content/FullscreenRow/FullscreenToggle/Fire

@onready var master_slider: HSlider = $Background/CenterContainer/PanelContainer/MarginContainer/Content/MasterRow/MasterSlider
@onready var music_slider: HSlider = $Background/CenterContainer/PanelContainer/MarginContainer/Content/MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $Background/CenterContainer/PanelContainer/MarginContainer/Content/SfxRow/SfxSlider

@onready var back_button: DefaultButton = $Background/CenterContainer/PanelContainer/MarginContainer/Content/BackButton
@onready var navigation_legend: NavigationLegend = $NavigationLegend

func _ready() -> void:
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	back_button.pressed.connect(_on_back_pressed)

	hide()

func grab_initial_focus() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.OPEN_MENU)
	_load_current_settings()
	fullscreen_toggle.grab_focus()

func close_ui() -> void:
	hide()

func cancel_action() -> void:
	_on_back_pressed()

func _load_current_settings() -> void:
	fullscreen_toggle.set_pressed_no_signal(SettingsManager.fullscreen)
	fullscreen_fire.visible = SettingsManager.fullscreen
	master_slider.value = SettingsManager.master_volume
	music_slider.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume

func _on_fullscreen_toggled(pressed: bool) -> void:
	fullscreen_fire.visible = pressed
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.BUTTON_CLICK)
	SettingsManager.set_fullscreen(pressed)

func _on_master_volume_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)

func _on_music_volume_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)

func _on_back_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.CLOSE_MENU)
	UIManager.close_top_menu()
	closed.emit()