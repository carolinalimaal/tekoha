extends State

@export var npc_iara_scene: PackedScene

const NPC_IARA_POSITION := Vector2(1106, 704)

var npc_iara_instance: Node2D

func _enter() -> void:
	if npc_iara_scene and !npc_iara_instance:
		npc_iara_instance = npc_iara_scene.instantiate()
		npc_iara_instance.position = NPC_IARA_POSITION
		owner_node.add_child(npc_iara_instance)

func _exit() -> void:
	if npc_iara_instance:
		npc_iara_instance.queue_free()
		npc_iara_instance = null
