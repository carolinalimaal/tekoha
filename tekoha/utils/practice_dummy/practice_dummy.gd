extends StaticBody2D

enum TutorialState {
	NOT_INITIATED,
	ATTACK_1,
	ATTACK_2,
	ROLL,
	FINISHED
}
var current_state: TutorialState = TutorialState.NOT_INITIATED

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_comp: HitboxComponent = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/HitBoxCollision
@onready var interaction_area: Area2D = $InteractionArea
@onready var tutorial_limit_1: StaticBody2D = $Limits/TutorialLimit
@onready var tutorial_limit_2: StaticBody2D = $Limits/TutorialLimit
@onready var interaction_ui: CanvasLayer = $InteractionUI
var tutorial_visited: bool = false
var can_interact: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox_comp.attack_received.connect(_on_attack_received)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player and !tutorial_visited:
		interaction_ui.show()
		can_interact = true

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact"):
		if !tutorial_visited and can_interact:
			start_tutorial()
	#mudar para o estado finished
	if InputManager.get_action_pressed("roll") and current_state == TutorialState.ROLL:
		print("Roll realizado")
		end_tutorial()

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is Player:
		interaction_ui.hide()
		can_interact = false

func _on_attack_received(attack_data: AttackData):
	if current_state != TutorialState.NOT_INITIATED:
		match current_state:
			TutorialState.ATTACK_1:
				if attack_data.damage_value == 4:
					print("Ataque 1 realizado")
					current_state = TutorialState.ATTACK_2
		
			TutorialState.ATTACK_2:
				if attack_data.damage_value == 6:
					print("Ataque 2 realizado")
					current_state = TutorialState.ROLL

func start_tutorial() -> void:
	interaction_area.hide()
	tutorial_limit_1.set_collision_layer_value(8, true)
	tutorial_limit_2.set_collision_layer_value(8, true)
	print("Tutorial iniciado")
	current_state = TutorialState.ATTACK_1
	
func end_tutorial():
	print("Tutorial finalizado")
	current_state = TutorialState.FINISHED
	tutorial_limit_1.set_collision_layer_value(8, false)
	tutorial_limit_2.set_collision_layer_value(8, false)
