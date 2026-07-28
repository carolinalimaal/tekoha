extends State

const FADE_DURATION := 1.5

func _enter() -> void:
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	owner_node.animation_player.stop()
	owner_node.health_ui.hide()
	owner_node.crab_spawn_area.stop_spawning()
	_kill_remaining_crabs()

	var tween := owner_node.create_tween()
	tween.tween_property(owner_node.body, "modulate:a", 0.0, FADE_DURATION)
	tween.parallel().tween_property(owner_node.tail, "modulate:a", 0.0, FADE_DURATION)
	tween.tween_callback(func(): owner_node.death_sequence_finished.emit())

func _kill_remaining_crabs() -> void:
	for child in owner_node.get_parent().get_children():
		if child is CaranguejoEnemy and not child.is_dead:
			child.health_component.died.emit()
