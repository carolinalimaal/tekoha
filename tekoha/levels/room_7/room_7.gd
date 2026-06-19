extends Level

enum Phase { CECILIA_TALK, APPROACHING_EXIT, DONE }
var _phase: Phase = Phase.CECILIA_TALK

@onready var room_7_door: Door = $Room7Door
@onready var room_8_door: Door = $Room8Door
@onready var path_block2: PathBlock = $PathBlock2
@onready var cecilia: NPC = $NpcCecila
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if GameManager.current_save.game_state == GameManager.GameState.SECOND_MEETING_CECILIA:
		GameManager.set_game_state(GameManager.GameState.IN_KITCHEN)
		_auto_save()
	
	room_7_door.set_deferred("monitoring", false)
	room_8_door.set_deferred("monitoring", false)
	
	cecilia.npc_dialogue = cecilia.dialogues_list[0]
	
	area_2d.body_entered.connect(_on_exit_area_entered)
	area_2d.set_deferred("monitoring", false)

	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _exit_tree() -> void:
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	if area_2d.body_entered.is_connected(_on_exit_area_entered):
		area_2d.body_entered.disconnect(_on_exit_area_entered)

func _on_exit_area_entered(body: Node2D) -> void:
	if body is Player:
		cecilia.interact()

func _on_dialogue_ended() -> void:
	match _phase:
		Phase.CECILIA_TALK:
			if cecilia.current_dialogue_index == 0:
				_after_first_dialogue()
		Phase.APPROACHING_EXIT:
			if cecilia.current_dialogue_index == 1:
				_after_exit_dialogue()

func _after_first_dialogue() -> void:
	_phase = Phase.APPROACHING_EXIT
	GlobalRefs.inventory.add_item(load("res://data/items/tambaqui_assado.tres") as ConsumableItemData)
	cecilia.npc_dialogue = cecilia.dialogues_list[1]
	cecilia.interactable_component.disable_interaction()
	path_block2.set_deferred("monitoring", false)
	area_2d.set_deferred("monitoring", true)

func _after_exit_dialogue() -> void:
	_phase = Phase.DONE
	area_2d.set_deferred("monitoring", false)
	cecilia.interactable_component.disable_interaction()
	room_8_door.set_deferred("monitoring", true)

func _auto_save() -> void:
	await get_tree().process_frame
	SaveManager.save_game(GameManager.current_save)
