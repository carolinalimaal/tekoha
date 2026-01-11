extends StaticBody2D

var opened: bool = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_player_interact_area_body_entered(body: Node2D) -> void:
	if body is Player:
		$InteractionUI.visible = true
		

func _on_player_interact_area_body_exited(body: Node2D) -> void:
	if body is Player:
		$InteractionUI.visible = false
