class_name RollStatePlayer 
extends State

var _roll_timer : Timer

func _ready() -> void:
	# Criar o timer, conectar sinal de timeout e adicionar o timer na arvore
	_roll_timer = Timer.new()
	_roll_timer.one_shot = true
	_roll_timer.autostart = false
	_roll_timer.timeout.connect(_on_roll_timer_timeout)
	add_child(_roll_timer)

func _enter() -> void:
	owner_node.can_roll = false
	# Pegar a direcao da rolagem e aplicar o movimento
	var roll_direction = owner_node.get_aim_direction()
	owner_node.roll_direction = roll_direction if roll_direction != Vector2.ZERO else owner_node.facing_direction
	owner_node.velocity = owner_node.roll_direction * owner_node.ROLL_SPEED
	# Desabilitar a hitbox_collision
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", true)
	# Atribuir o tempo de cooldown
	_roll_timer.wait_time = owner_node.roll_cooldown
	# Conectar o sinal animation_finished
	owner_node.animation_tree.animation_finished.connect(_on_animation_finished)

func _exit() -> void:
	owner_node.velocity = Vector2.ZERO
	# Atualizar a facing_direction
	owner_node.facing_direction = owner_node.roll_direction
	# Habilitar a hitbox_collision
	owner_node.hitbox_component.hitbox_collision.set_deferred("disabled", false)
	# Desconectar o sinal de animation_finished (evitar conflito com outros estados)
	owner_node.animation_tree.animation_finished.disconnect(_on_animation_finished)
	# Iniciar o timer do cooldown
	_roll_timer.start()

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func _on_roll_timer_timeout() -> void:
	# Quando o timer acabar, flag can_roll permite rolar novamente
	owner_node.can_roll = true

func _on_animation_finished(anim_name: StringName) -> void:
	# No fim da animacao de rolagem, volta para IDLE
	if anim_name in ["roll_down", "roll_up", "roll_left", "roll_right"]:
		transition_to("idle")
		return
