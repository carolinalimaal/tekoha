extends Level

@export var bg_music: AudioStream
@export var sacola_scene: PackedScene
@export var canudinho_scene: PackedScene

var spawn_enemies_triggered: bool = false

@onready var enemy_spawn_points: Node2D = $FingerEnemies/EnemySpawnPoints
@onready var spawn_enemies_trigger: Area2D = $FingerEnemies/SpawnEnemiesTrigger

func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
	spawn_enemies_trigger.body_entered.connect(_on_body_entered_in_spawn_enemies_trigger)

func _exit_tree() -> void:
	if spawn_enemies_trigger.body_entered.is_connected(_on_body_entered_in_spawn_enemies_trigger):
		spawn_enemies_trigger.body_entered.disconnect(_on_body_entered_in_spawn_enemies_trigger)

func _on_body_entered_in_spawn_enemies_trigger(body: Node2D) -> void:
	if body is Player and !spawn_enemies_triggered:
		_spawn_enemies()

func _spawn_enemies() -> void:
	spawn_enemies_triggered = true
	
	for point in enemy_spawn_points.get_children():
		if point is Marker2D:
			var enemy_instance
			if "Sacola" in point.name:
				enemy_instance = sacola_scene.instantiate()
			else:
				enemy_instance = canudinho_scene.instantiate()
			enemy_instance.global_position = point.global_position
			call_deferred("add_child", enemy_instance)
