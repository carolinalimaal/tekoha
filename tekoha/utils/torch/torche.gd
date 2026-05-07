extends StaticBody2D

signal torch_turnned_off(torch_id)

var hit_numbers: int = 0
var can_be_damaged: bool = true
@export var torch_id: int

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/HitBoxCollision

@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	hitbox_component.attack_received.connect(_on_torch_attack_received)
	

func _on_torch_attack_received(_attack_data: AttackData):
	if can_be_damaged:
		can_be_damaged = false
		hit_numbers += 1
		match hit_numbers:
			1:
				print(1)
				animated_sprite_2d.play("first_hit")
				await  animated_sprite_2d.animation_finished
				animated_sprite_2d.play("default")
			2:
				print(2)
				animated_sprite_2d.play("second_hit")
				await  animated_sprite_2d.animation_finished
				animated_sprite_2d.play("default")
			3:
				print(3)
				animated_sprite_2d.play("second_hit")
				await  animated_sprite_2d.animation_finished
				animated_sprite_2d.play("third_hit")
				torch_off()
		can_be_damaged = true
	

func torch_off():
	hitbox_component.set_deferred("monitoring", false)
	hitbox_collision.set_deferred("disabled", true)
	torch_turnned_off.emit(torch_id)
