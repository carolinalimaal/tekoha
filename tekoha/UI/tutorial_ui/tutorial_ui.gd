extends CanvasLayer

@onready var control: Control = $Control
@onready var check_1: TextureRect = $Control/Background/MarginContainer/TaskList/Task1/Box/Check
@onready var check_2: TextureRect = $Control/Background/MarginContainer/TaskList/Task2/Box/Check
@onready var check_3: TextureRect = $Control/Background/MarginContainer/TaskList/Task3/Box/Check

func _ready() -> void:
	control.modulate.a = 0.0
	check_1.modulate.a = 0.0
	check_2.modulate.a = 0.0
	check_3.modulate.a = 0.0
	

# Animação para mostrar a caixa
func show_ui() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(control, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE)

# Animação para esconder a caixa
func hide_ui() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(control, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)

# Funções chamadas pelo Tutorial
func mark_attack_1_done() -> void:
	_animate_check(check_1)

func mark_attack_2_done() -> void:
	_animate_check(check_2)

func mark_roll_done() -> void:
	_animate_check(check_3)

# Lógica de animação do checkbox
func _animate_check(check_node: TextureRect) -> void:
	var tween: Tween = create_tween()
	
	# Configura o pivô para o centro para que ele cresça do meio para fora
	check_node.pivot_offset = check_node.size / 2.0 
	check_node.scale = Vector2(0.3, 0.3) # Começa pequeno
	
	tween.set_parallel(true) # Faz as duas animações abaixo rodarem ao mesmo tempo
	tween.tween_property(check_node, "modulate:a", 1.0, 0.3)
	# TRANS_BACK dá aquele efeito de pulo"
	tween.tween_property(check_node, "scale", Vector2(1, 1), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
