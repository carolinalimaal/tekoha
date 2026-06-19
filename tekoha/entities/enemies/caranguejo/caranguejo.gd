class_name Caranguejo
extends CharacterBody2D

@export var take_damage_effect: Shader
@export var death_effect: Shader

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	die()

func apply_damage():
	var take_damage_material = ShaderMaterial.new()
	take_damage_effect.shader = take_damage_effect
	sprite_2d.material = take_damage_material
	
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blink_intensity, 1.0, 0.0, 0.5)

func set_shader_blink_intensity(new_value: float) -> void:
	sprite_2d.material.set_shader_parameter("blink_intensity", new_value)

func die() -> void:
	var death_material = ShaderMaterial.new()
	death_effect.shader = death_effect
	sprite_2d.material = death_material

	var tween = get_tree().create_tween()
	tween.tween_method(set_death_progress, 0.0, 1.0, 1.2)
	tween.tween_callback(queue_free)

func set_death_progress(value: float) -> void:
	sprite_2d.material.set_shader_parameter("progress", value)
