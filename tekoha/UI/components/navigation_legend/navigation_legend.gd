class_name NavigationLegend
extends MarginContainer

@export var legend_text: String
@export var icon_size: int = 24

@onready var legend: RichTextLabel = $Legend

func _ready() -> void:
	InputManager.input_source_changed.connect(_on_input_source_changed)
	_update_visuals()

func _update_visuals() -> void:
	if legend_text:
		legend.text = InputManager.icon_mapper.parse_input_text(legend_text, icon_size)

func _on_input_source_changed(_source: InputManager.InputSource) -> void:
	_update_visuals()

func set_legend_text(text: String) -> void:
	legend_text = text
	_update_visuals()
