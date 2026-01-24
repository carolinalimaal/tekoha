class_name Pote extends StaticBody2D

@export var sprite: CompressedTexture2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/HitboxCollision

@onready var collision: CollisionShape2D = $Collision

func _ready() -> void:
	sprite_2d.texture = sprite
	
	hitbox_component.attack_received.connect(_on_pot_attack_received)
	health_component.died.connect(_on_pot_destroyed)
	
func _on_pot_attack_received(attack_data: AttackData):
	health_component.take_damage(attack_data)
	sprite_2d.frame = min(floor(abs(health_component.max_health - health_component.current_health) / 4), 4)
	
func _on_pot_destroyed():
	hitbox_component.set_deferred("monitoring", false)
	hitbox_collision.set_deferred("disabled", true)
	collision.set_deferred("disabled", true)
