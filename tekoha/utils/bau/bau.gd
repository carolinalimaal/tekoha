class_name Bau extends StaticBody2D

@export var id: int
@export var item: ConsumableItemData
@export var sprite_frames: SpriteFrames

var is_showing: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void:
	sprite.sprite_frames = sprite_frames
	
	if GameManager.current_save.opened_chests.has(id):
		item = null

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact") and is_showing:
		# Se o input for consumido aqui, nao propaga para o resto dos _unhandled_input do jogo
		get_viewport().set_input_as_handled()
		close_chest()

func interact() -> void:
	update_item_panel()
	open_chest()

func update_item_panel():
	if item == null:
		GlobalRefs.confirmation_popup.setup("O BAÚ ESTÁ VAZIO.", null, false)
	elif verify_full_inventory():
		GlobalRefs.confirmation_popup.setup("SEU INVENTÁRIO ESTÁ CHEIO.", null, false)
	elif item:
		var text = "??? ENCONTRADO!" if !GameManager.current_save.known_items.has(item.name) else item.name.to_upper() + " ENCONTRADO!"
		GlobalRefs.confirmation_popup.setup(text, item.icon, true, "Pegar")

func open_chest():
	UIManager.is_interact_ui_open = true
	get_tree().paused = true
	
	sprite.play("bau_animation")
	interactable_component.disable_interaction()
	await sprite.animation_finished
	
	is_showing = true
	
	if !GlobalRefs.confirmation_popup.confirmed.is_connected(_on_chest_confirmed):
		GlobalRefs.confirmation_popup.confirmed.connect(_on_chest_confirmed)
	if !GlobalRefs.confirmation_popup.cancelled.is_connected(_on_chest_cancelled):
		GlobalRefs.confirmation_popup.cancelled.connect(_on_chest_cancelled)
		
	UIManager.open_menu("confirmation")

func close_chest():
	UIManager.is_interact_ui_open = false
	is_showing = false
	
	UIManager.close_top_menu() 
	
	sprite.play_backwards("bau_animation")
	interactable_component.enable_interaction()
	
	if GlobalRefs.confirmation_popup.confirmed.is_connected(_on_chest_confirmed):
		GlobalRefs.confirmation_popup.confirmed.disconnect(_on_chest_confirmed)
	if GlobalRefs.confirmation_popup.cancelled.is_connected(_on_chest_cancelled):
		GlobalRefs.confirmation_popup.cancelled.disconnect(_on_chest_cancelled)

func _on_chest_confirmed() -> void:
	GlobalRefs.inventory.add_item(item)
	GameManager.current_save.opened_chests[id] = true
	print("Item adicionado ao inventário!")
	
	var is_new_item = !GameManager.current_save.known_items.has(item.name)
	var _item = item
	
	item = null
	close_chest()
	
	if is_new_item:
		GameManager.current_save.known_items[_item.name] = true
		GlobalRefs.new_item_found_panel.show_panel(GlobalRefs.ItemType.FOOD, _item)

func _on_chest_cancelled() -> void:
	close_chest()

func verify_full_inventory() -> bool:
	return GlobalRefs.inventory._get_empty_item_slot() == null
