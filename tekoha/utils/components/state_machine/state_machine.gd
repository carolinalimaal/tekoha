class_name StateMachine 
extends Node

@export var _initial_state: State

var states: Dictionary = {}
var current_state: State
var previous_state: State

func _process(delta: float) -> void:
	if current_state:
		current_state._update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update(delta)

# Preencher o dict com todos os estados
func init(owner_node: Node2D) -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
			child.owner_node = owner_node
			child.Transitioned.connect(change_state)
	
	if _initial_state:
		change_state(_initial_state.name)

# Mudar de estado
func change_state(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state == new_state:
		return
	if current_state:
		previous_state = current_state
		current_state._exit()
	current_state = new_state
	current_state._enter()
