class_name HealthComponent
extends Node

signal health_changed(current_health: float, max_health: float)
signal died

@export var _max_health: float

var _current_health: float

func _ready() -> void:
	_current_health = _max_health

func take_damage(attack_data: AttackData) -> void:
	_current_health -= attack_data.damage_value
	_current_health = max(0, _current_health)
	
	health_changed.emit(_current_health, _max_health)
	
	if _current_health == 0:
		_die()

func heal(amout: float) -> void:
	_current_health += amout
	_current_health = min(_current_health, _max_health)
	
	health_changed.emit(_current_health, _max_health)

func _die() -> void:
	died.emit()
