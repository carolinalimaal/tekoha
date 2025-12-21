class_name Enemy
extends CharacterBody2D

static var enemies_attacking: int = 0
static var max_attackers: int = 2

@export_category("Speed")
@export var patrol_speed: float = 50
@export var chase_speed: float = 60 
@export var attack_speed: float = 80

var move_direction: Vector2
var facing_direction: Vector2
var last_known_player_position: Vector2

var anim_transition: int = 0

var can_attack: bool = true

var animation_tree: AnimationTree
var state_machine: StateMachine
var nav_agent: NavigationAgent2D

func get_direction_to_player() -> Vector2:
	if GlobalRefs.player:
		return global_position.direction_to(GlobalRefs.player.global_position)
	return Vector2.ZERO

func get_distance_sqr_to_player() -> float:
	if GlobalRefs.player:
		return global_position.distance_squared_to(GlobalRefs.player.global_position)
	return INF

func is_attack_allowed() -> bool:
	return enemies_attacking < max_attackers

func register_attacker() -> void:
	enemies_attacking += 1

func deregister_attacker() -> void:
	enemies_attacking = max(0, enemies_attacking - 1)
