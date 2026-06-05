class_name Torch extends StaticBody2D

signal puzzle_activator()

@export var torch_id: int

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/HitBoxCollision

@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	hitbox_component.attack_received.connect(_on_torch_attack_received)
	if GameManager.current_save.game_state >= GameManager.GameState.AFTER_PUZZLE_1:
		animated_sprite_2d.play("third_hit")

func _on_torch_attack_received(_attack_data: AttackData):
	if _attack_data.damage_value < 6:
		animated_sprite_2d.play("first_hit")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("default")
	else:
		animated_sprite_2d.play("second_hit")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("third_hit")
		torch_off()

func torch_off():
	hitbox_component.set_deferred("monitoring", false)
	hitbox_collision.set_deferred("disabled", true)
	puzzle_activator.emit()
