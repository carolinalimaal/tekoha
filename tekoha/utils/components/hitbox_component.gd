class_name HitboxComponent
extends Area2D

signal attack_received(attack_data: AttackData)

@export var hitbox_collision : CollisionShape2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: Area2D) -> void:
	if hurtbox is HurtboxComponent:
		hurtbox.attack_data.attack_direction = hurtbox.global_position
		attack_received.emit(hurtbox.attack_data)
		var attacker = hurtbox.get_parent()
		if attacker.is_in_group('projectile'):
			attacker.queue_free()
