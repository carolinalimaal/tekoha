extends StaticBody2D

signal damage_received(attack_data: AttackData)

@export var tutorial_dummy: bool
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_comp: HitboxComponent = $HitboxComponent


func _ready() -> void:
	hitbox_comp.attack_received.connect(_on_attack_received)


func _on_attack_received(attack_data: AttackData):
	animated_sprite.play("damage_anim")
	if tutorial_dummy:
		print("Ataque recebido")
		damage_received.emit(attack_data)
