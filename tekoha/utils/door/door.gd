class_name Door extends Area2D

# Isso cria um botão no Inspetor para você selecionar o arquivo .tscn, 
# mas salva apenas o texto do caminho, evitando a dependência circular!
@export_file("*.tscn") var target_level_path: String
@export var door_name: String

func _ready() -> void:
	GlobalSignals.animation_midpoint_reached.connect(on_animation_midpoint_reached)
	body_entered.connect(_on_player_body_entered)
	
func _on_player_body_entered(body: Node2D) -> void:
	get_tree().paused = true
	GlobalSignals.emit_signal("door_entered")
	
func on_animation_midpoint_reached() -> void:
	if target_level_path == "":
		push_error("Caminho do level não definido na porta!")
		return

	# Carrega a cena dinamicamente a partir do texto
	var next_level_scene = load(target_level_path)
	var level_instance = next_level_scene.instantiate()
	
	# Navegando pela sua árvore (Door -> Level1 -> Level)
	var current_level = get_parent() 
	var level_container = current_level.get_parent()
	
	# Usamos call_deferred para adicionar e remover os nós de forma segura 
	# no final do frame de física atual
	level_container.call_deferred("add_child", level_instance)
	current_level.queue_free() # queue_free() é o ideal para deletar e limpar a memória da cena velha
	
	
	current_level = level_instance
	var level_door = level_instance.get_node(door_name)
	var level_door_marker = level_door.get_node("Marker2D")
	var spawn_point = level_door_marker.global_position
	
	GlobalRefs.player.global_position = spawn_point
	GlobalSignals.emit_signal("level_loading_finished")
	
