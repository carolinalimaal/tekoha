class_name ControllerManager
extends Node

signal controller_connected(device_id: int)
signal controller_disconnected(device_id: int)

enum ControllerType {
	PLAYSTATION,
	XBOX,
}

@export var analog_deadzone: float = 0.2
@export var trigger_threshold: float = 0.5

var connected_controllers = {}
var active_controller = -1


func _ready() -> void:
	for device_id in Input.get_connected_joypads():
		_register_controller(device_id)
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func get_connected_controller_list() -> Dictionary:
	return connected_controllers

func get_active_controller() -> int:
	return active_controller

func set_active_controller(device_id) -> bool:
	if connected_controllers.has(device_id):
		active_controller = device_id
		return true
	return false
 
func get_controller_stick_input(device_id: int = -1, left_stick: bool = true) -> Vector2:
	if device_id == -1:
		device_id = active_controller
	if device_id == -1 or !connected_controllers.has(device_id):
		return Vector2.ZERO
	
	var x_axis = JOY_AXIS_LEFT_X if left_stick else JOY_AXIS_RIGHT_X
	var y_axis = JOY_AXIS_LEFT_Y if left_stick else JOY_AXIS_RIGHT_Y
	
	var input_vector = Vector2(
		Input.get_joy_axis(device_id, x_axis),
		Input.get_joy_axis(device_id, y_axis)
	)
	
	if input_vector.length() < analog_deadzone:
		return Vector2.ZERO
	return input_vector    

#func is_controller_button_pressed(button: JoyButton,device_id: int = -1) -> bool:
	#if device_id == -1:
		#device_id = active_controller
	#if device_id == -1 or !connected_controllers.has(device_id):
		#return false
	#return Input.is_joy_button_pressed(device_id, button)

#func is_controller_trigger_pressed(device_id: int = -1, left_trigger: bool = true) -> float:
	#if device_id == -1:
		#device_id = active_controller
	#if device_id == -1 or !connected_controllers.has(device_id):
		#return 0.0
	#
	#var axis = JOY_AXIS_TRIGGER_LEFT if left_trigger else JOY_AXIS_TRIGGER_RIGHT
	#var value = Input.get_joy_axis(device_id, axis)
	#
	#if value > trigger_threshold:
		## Normalizando o valor
		#return (value + 1) /2
	#return 0.0

func _register_controller(device_id: int) -> void:
	if connected_controllers.has(device_id):
		return
	
	var joy_name = Input.get_joy_name(device_id)
	var controller_type = _guess_controller_type(joy_name)
	
	connected_controllers[device_id] = {
		"name" : joy_name,
		"guid" : Input.get_joy_guid(device_id),
		"type" : controller_type
	}
	
	if active_controller == -1:
		active_controller = device_id
	
	controller_connected.emit(device_id)

func _deregister_controller(device_id: int) -> void:
	if connected_controllers.has(device_id):
		var controller_name = connected_controllers[device_id].name
		connected_controllers.erase(device_id)
		
		if active_controller == device_id:
			active_controller = -1
			if !connected_controllers.is_empty():
				active_controller = connected_controllers.keys()[0]
		controller_disconnected.emit(device_id)

func _on_joy_connection_changed(device_id: int, connected: bool) -> void:
	if connected:
		_register_controller(device_id)
	else:
		_deregister_controller(device_id)

func _guess_controller_type(joy_name: String) -> ControllerType:
	var lower_joy_name: String = joy_name.to_lower()
	if contains_any_of(lower_joy_name, ["ps5", "ps-5", "ps 5", "ps4", "ps-4", "ps 4", "playstation", "play station", "play-station", "dualshock"]):
		return ControllerType.PLAYSTATION
	else:
		return ControllerType.XBOX

func contains_any_of(compare_string: String, strings: Array[String]) -> bool:
	var lowercase_string := compare_string.to_lower()
	for string in strings:
		if lowercase_string.contains(string):
			return true
	return false
