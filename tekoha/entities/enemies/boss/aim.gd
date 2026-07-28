extends State


@onready var attack: Node2D = $"../../Attack"

var _distance_to_player: float
var _aim_speed: float = 200
var target_position : Vector2 = Vector2.ZERO


func _ready() -> void:
	pass

func _enter():
	if GlobalRefs.player:
		var player : Player = get_tree().get_first_node_in_group("player")
		attack.global_position = player.global_position
	owner_node.animation_player.play("Aim")

func _exit():
	pass

func _update(_delta: float):
	if GlobalRefs.player:
		get_target()
		attack.global_position = attack.global_position.lerp(target_position - Vector2(0, 5.5), 1 - exp(-_delta * 6.5))
		

func get_target():
	var player : Player = get_tree().get_first_node_in_group("player")
	if player:
		target_position = player.global_position

func _physics_update(_delta: float):
	pass
	
func start_attack():
	if randi_range(0, 3) < 3:
		owner_node.animation_player.play("Attack")
		transition_to("Attack")
	else:
		owner_node.animation_player.play("Attack2")
	
