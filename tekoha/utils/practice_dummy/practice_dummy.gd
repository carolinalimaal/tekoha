extends StaticBody2D

signal damage_received(attack_data: AttackData)

@export var tutorial_dummy: bool
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_comp: HitboxComponent = $HitboxComponent


func _ready() -> void:
	hitbox_comp.attack_received.connect(_on_attack_received)


func _on_attack_received(attack_data: AttackData):
	animated_sprite.play("damage_anim")
	if current_state != TutorialState.NOT_INITIATED:
		match current_state:
			TutorialState.ATTACK_1:
				if attack_data.damage_value == 4:
					print("Ataque 1 realizado")
					current_state = TutorialState.ATTACK_2
					GlobalRefs.player.can_attack_2 = true
					index += 1
					DialogueManager.start_speech(tutorial_instructions[index])
					update_ui()
		
			TutorialState.ATTACK_2:
				if attack_data.damage_value == 6:
					print("Ataque 2 realizado")
					current_state = TutorialState.ROLL
					GlobalRefs.player.can_roll = true
					index += 1
					DialogueManager.start_speech(tutorial_instructions[index])
					update_ui()

func _on_finish_timer_timeout() -> void:
	zoom_out_camera()
	interaction_ui.hide()


func start_tutorial() -> void:
	interaction_area.hide()
	set_limits_layer(true)
	zoom_in_camera()
	print("Tutorial iniciado")
	current_state = TutorialState.ATTACK_1
	GlobalRefs.player.can_attack_1 = true
	update_ui()
	DialogueManager.start_speech(tutorial_instructions[index])
	
func end_tutorial():
	current_state = TutorialState.FINISHED
	print("Tutorial finalizado")
	set_limits_layer(false)
	update_ui()
	

func set_limits_layer(condition: bool):
	tutorial_limit_1.set_collision_layer_value(8, condition)
	tutorial_limit_2.set_collision_layer_value(8, condition)

func update_ui():
	match current_state:
		TutorialState.ATTACK_1:
			interaction_container_adjustments(967, 313)
			int_ui_label.text = "Clique no botão esquerdo para atacar"
		
		TutorialState.ATTACK_2:
			interaction_container_adjustments(750, 530)
			int_ui_label.text = "Clique no botão esquerdo duas vezes para realizar o ataque duplo"
		
		TutorialState.ROLL:
			interaction_container_adjustments(915, 365)
			int_ui_label.text = "Clique no botão direito para realizar o Dash"
		
		TutorialState.FINISHED:
			interaction_container_adjustments(1107, 173)
			int_ui_label.text = "Tutorial finalizado!"
			finish_timer.start()

func interaction_container_adjustments(pos: int, size: int):
	int_container.position.x = pos
	int_container.size.x = size

func zoom_in_camera():
	var tween: Tween = create_tween()
	tween.tween_property(get_node("../../../PlayerCamera"), "zoom", Vector2(2,2), 1)
	
func zoom_out_camera():
	var tween: Tween = create_tween()
	tween.tween_property(get_node("../../../PlayerCamera"), "zoom", Vector2(1,1), 1)
	if tutorial_dummy:
		print("Ataque recebido")
		damage_received.emit(attack_data)
