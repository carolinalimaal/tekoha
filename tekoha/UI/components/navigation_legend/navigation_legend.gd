class_name NavigationLegend
extends MarginContainer

@export_multiline() var legend_text: String
@export var icon_size: int = 32

@onready var legend: RichTextLabel = $Legend

func _ready() -> void:
	InputManager.input_source_changed.connect(_on_input_source_changed)
	InputManager.active_controller_changed.connect(_on_controller_swapped)
	_update_visuals()

func _update_visuals() -> void:
	if legend_text:
		legend.text = InputManager.icon_mapper.parse_input_text(legend_text, icon_size)

func _on_input_source_changed(_source: InputManager.InputSource) -> void:
	_update_visuals()

func _on_controller_swapped(_new_device_id: int) -> void:
	_update_visuals()

func set_legend_text(text: String) -> void:
	legend_text = text
	_update_visuals()
