class_name State 
extends Node

signal Transitioned(state_name: String)

@onready var owner_node: Node2D
@onready var state_machine: StateMachine

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func transition_to(state_name: String):
	Transitioned.emit(state_name)
