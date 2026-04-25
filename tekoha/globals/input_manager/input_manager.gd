extends Node

signal input_source_changed(source: InputSource)

enum InputSource {
	KEYBOARD,
	CONTROLLER,
}

var active_input_source = InputSource.KEYBOARD

var controller_manager: ControllerManager
var icon_mapper: IconMapper

func _ready() -> void:
	controller_manager = $ControllerManager
	icon_mapper = $IconMapper
	controller_manager.controller_connected.connect(_on_controller_connected)
	controller_manager.controller_disconnected.connect(_on_controller_disconnected)
	
	if controller_manager.active_controller != -1:
		_set_input_source(InputSource.CONTROLLER)
	else:
		_set_input_source(InputSource.KEYBOARD)

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		_set_input_source(InputSource.KEYBOARD)
	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion and abs(event.axis_value) > controller_manager.analog_deadzone):
		_set_input_source(InputSource.CONTROLLER)

func get_movement_vector() -> Vector2:
	match active_input_source:
		InputSource.KEYBOARD:
			return Input.get_vector("move_left", "move_right", "move_up", "move_down")
		InputSource.CONTROLLER:
			return controller_manager.get_controller_stick_input(controller_manager.active_controller)
	return Vector2.ZERO

func get_action_pressed(action_name: String):
	return Input.is_action_just_pressed(action_name)

func get_aim_direction() -> Vector2:
	match active_input_source:
		InputSource.KEYBOARD:
			return (GlobalRefs.player.get_global_mouse_position() - GlobalRefs.player.global_position)
		InputSource.CONTROLLER:
			return controller_manager.get_controller_stick_input(controller_manager.active_controller)
	return Vector2.ZERO

func _set_input_source(source: InputSource) -> void:
	if active_input_source != source:
		active_input_source = source
		print("InputSource mudou para: ", active_input_source)
		input_source_changed.emit(source)

func _on_controller_connected(_device_id: int) -> void:
	_set_input_source(InputSource.CONTROLLER)

func _on_controller_disconnected(_device_id: int) -> void:
	_set_input_source(InputSource.KEYBOARD)
