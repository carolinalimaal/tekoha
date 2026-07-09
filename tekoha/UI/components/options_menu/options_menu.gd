class_name OptionsMenu
extends Control

signal closed

const ROW_HIGHLIGHT_COLOR: Color = Color(1.0, 0.8, 0.45, 0.16)
const ROW_HIGHLIGHT_BORDER_COLOR: Color = Color(1.0, 0.75, 0.35, 0.9)

@onready var fullscreen_row_panel: PanelContainer = $Background/CenterContainer/PanelContainer/MarginContainer/Content/FullscreenRowPanel
@onready var fullscreen_toggle: Button = $Background/CenterContainer/PanelContainer/MarginContainer/Content/FullscreenRowPanel/FullscreenRow/FullscreenToggle
@onready var fullscreen_fire: TextureRect = $Background/CenterContainer/PanelContainer/MarginContainer/Content/FullscreenRowPanel/FullscreenRow/FullscreenToggle/Fire

@onready var master_row_panel: PanelContainer = $Background/CenterContainer/PanelContainer/MarginContainer/Content/MasterRowPanel
@onready var master_slider: HSlider = $Background/CenterContainer/PanelContainer/MarginContainer/Content/MasterRowPanel/MasterRow/MasterSlider
@onready var master_value_label: Label = $Background/CenterContainer/PanelContainer/MarginContainer/Content/MasterRowPanel/MasterRow/MasterValueLabel

@onready var music_row_panel: PanelContainer = $Background/CenterContainer/PanelContainer/MarginContainer/Content/MusicRowPanel
@onready var music_slider: HSlider = $Background/CenterContainer/PanelContainer/MarginContainer/Content/MusicRowPanel/MusicRow/MusicSlider
@onready var music_value_label: Label = $Background/CenterContainer/PanelContainer/MarginContainer/Content/MusicRowPanel/MusicRow/MusicValueLabel

@onready var sfx_row_panel: PanelContainer = $Background/CenterContainer/PanelContainer/MarginContainer/Content/SfxRowPanel
@onready var sfx_slider: HSlider = $Background/CenterContainer/PanelContainer/MarginContainer/Content/SfxRowPanel/SfxRow/SfxSlider
@onready var sfx_value_label: Label = $Background/CenterContainer/PanelContainer/MarginContainer/Content/SfxRowPanel/SfxRow/SfxValueLabel

@onready var back_button: DefaultButton = $Background/CenterContainer/PanelContainer/MarginContainer/Content/BackButton
@onready var navigation_legend: NavigationLegend = $NavigationLegend

var _row_focus_style: StyleBoxFlat
var _row_default_style: StyleBoxEmpty

func _ready() -> void:
	_setup_row_highlight_styles()

	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	fullscreen_toggle.focus_entered.connect(_on_row_focus_entered.bind(fullscreen_row_panel))
	fullscreen_toggle.focus_exited.connect(_on_row_focus_exited.bind(fullscreen_row_panel))

	master_slider.value_changed.connect(_on_master_volume_changed)
	master_slider.focus_entered.connect(_on_row_focus_entered.bind(master_row_panel))
	master_slider.focus_exited.connect(_on_row_focus_exited.bind(master_row_panel))

	music_slider.value_changed.connect(_on_music_volume_changed)
	music_slider.focus_entered.connect(_on_row_focus_entered.bind(music_row_panel))
	music_slider.focus_exited.connect(_on_row_focus_exited.bind(music_row_panel))

	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	sfx_slider.focus_entered.connect(_on_row_focus_entered.bind(sfx_row_panel))
	sfx_slider.focus_exited.connect(_on_row_focus_exited.bind(sfx_row_panel))

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

func _setup_row_highlight_styles() -> void:
	_row_focus_style = StyleBoxFlat.new()
	_row_focus_style.bg_color = ROW_HIGHLIGHT_COLOR
	_row_focus_style.border_color = ROW_HIGHLIGHT_BORDER_COLOR
	_row_focus_style.set_border_width_all(2)
	_row_focus_style.set_corner_radius_all(8)
	_row_focus_style.set_content_margin_all(8)

	_row_default_style = StyleBoxEmpty.new()
	_row_default_style.set_content_margin_all(8)

	for panel: PanelContainer in [fullscreen_row_panel, master_row_panel, music_row_panel, sfx_row_panel]:
		panel.add_theme_stylebox_override("panel", _row_default_style)

func _on_row_focus_entered(panel: PanelContainer) -> void:
	panel.add_theme_stylebox_override("panel", _row_focus_style)

func _on_row_focus_exited(panel: PanelContainer) -> void:
	panel.add_theme_stylebox_override("panel", _row_default_style)

func _load_current_settings() -> void:
	fullscreen_toggle.set_pressed_no_signal(SettingsManager.fullscreen)
	fullscreen_fire.visible = SettingsManager.fullscreen

	master_slider.value = SettingsManager.master_volume
	music_slider.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume

	_update_volume_label(master_value_label, SettingsManager.master_volume)
	_update_volume_label(music_value_label, SettingsManager.music_volume)
	_update_volume_label(sfx_value_label, SettingsManager.sfx_volume)

func _update_volume_label(label: Label, value: float) -> void:
	label.text = "%d%%" % int(round(value * 100))

func _on_fullscreen_toggled(pressed: bool) -> void:
	fullscreen_fire.visible = pressed
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.BUTTON_CLICK)
	SettingsManager.set_fullscreen(pressed)

func _on_master_volume_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)
	_update_volume_label(master_value_label, value)

func _on_music_volume_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)
	_update_volume_label(music_value_label, value)

func _on_sfx_volume_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)
	_update_volume_label(sfx_value_label, value)

func _on_back_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.CLOSE_MENU)
	UIManager.close_top_menu()
	closed.emit()
