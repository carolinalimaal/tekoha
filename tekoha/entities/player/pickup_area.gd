class_name PickupArea extends Area2D

var inventory: Inventory

@onready var interact_ui: CanvasLayer = $"../InteractUI"

var item: PickupItem

func _ready() -> void:
	area_entered.connect(_on_item_entered_in_pickupArea)
	area_exited.connect(_on_item_exited_in_pickupArea)
	
	inventory = GlobalRefs.inventory

func _on_item_entered_in_pickupArea(item_entered: Area2D):
	if item_entered is not Coin and item_entered is not Muiraquita and item_entered.item_data is ConsumableItemData:
		interact_ui.visible = true
		item = item_entered
		
	elif item_entered is Coin or item_entered is Muiraquita:
		item_entered.collect()

func _on_item_exited_in_pickupArea(_item: Area2D):
	interact_ui.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interact_ui.visible == true:
		if inventory.add_item(item.item_data):
			await get_tree().create_timer(.3).timeout
			item.queue_free()
