extends State

@export var projectile: PackedScene
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
	_attack_cooldown_timer.wait_time = randf_range(1.5, 2.5)
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
	# Desconectar sinal de animation_finished
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_tree_animation_finished)

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	pass

func _shoot():
	if GlobalRefs.player:
		var projectile_instance: Projectile = projectile.instantiate()
		get_tree().current_scene.add_child(projectile_instance)
		projectile_instance.global_position = owner_node.aiming_point.global_position
		projectile_instance.direction = owner_node.get_direction_to_player()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["attack_down", "attack_up", "attack_left", "attack_right"] and GlobalRefs.player:
		transition_to("Surround")
		return

func _on_attack_cooldown_timer_timeout() -> void:
		owner_node.can_attack = true
