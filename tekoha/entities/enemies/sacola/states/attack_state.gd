extends State

var _attack_cooldown_timer: Timer

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_attack_cooldown_timer = Timer.new()
	_attack_cooldown_timer.one_shot = true
	_attack_cooldown_timer.autostart = false
	_attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)
	add_child(_attack_cooldown_timer)

func _enter():
	# Atualizar a flag
	owner_node.can_attack = false
	# Gerar um cooldown aleatorio
	_attack_cooldown_timer.wait_time = randf_range(0.8, 2.0)
	# Registra que há um inimigo atacando
	owner_node.register_attacker()
	owner_node.velocity = Vector2.ZERO
	if GlobalRefs.player:
		# Atualizar facing_direction
		owner_node.facing_direction = owner_node.get_direction_to_player()
	# Conectar sinal de animation_finished
	owner_node.animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func _exit():
	# Iniciar timer do cooldown
	_attack_cooldown_timer.start()
	# Remove o registro do inimigo atacando
	owner_node.deregister_attacker()
	owner_node.velocity = Vector2.ZERO
	# Desabilitar a hurtbox_collision
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", true)
	# Desconectar sinal de animation_finished
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_tree_animation_finished)

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	pass

func _attack():
	# Habilitar a hurtbox_collision
	owner_node.hurtbox_component.hurtbox_collision.set_deferred("disabled", false)
	#owner_node.velocity = owner_node.move_direction * owner_node.attack_speed

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["attack_down", "attack_up", "attack_left", "attack_right"] and GlobalRefs.player:
		transition_to("Aiming")
		return

func _on_attack_cooldown_timer_timeout() -> void:
	owner_node.can_attack = true
