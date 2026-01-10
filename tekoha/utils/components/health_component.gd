class_name HealthComponent
extends Node

signal died

@export var max_health: int

var current_health: int

func _ready() -> void:
	current_health = max_health

func take_damage(attack_data: AttackData) -> void:
	current_health -= attack_data.damage_value
	current_health = max(0, current_health)
	
	if current_health == 0:
		_die()

func heal(amout: int) -> void:
	current_health += amout
	current_health = min(current_health, max_health)
	print("vida após curar: ", current_health)

	

func _die() -> void:
	died.emit()
