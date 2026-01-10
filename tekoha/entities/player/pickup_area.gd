class_name PickupArea extends Area2D

var inventory: Inventory

@onready var interact_ui: CanvasLayer = $"../InteractUI"

#var item: PickupItem

func _ready() -> void:
	area_entered.connect(_on_pickup_area_area_entered)
	area_exited.connect(_on_pickup_area_area_exited)
	
	inventory = GlobalRefs.inventory

func _on_pickup_area_area_entered(item_entered: Area2D):
	if item_entered is Coin or item_entered is Muiraquita:
		item_entered.collect()
	
	#elif item_entered.item_data is ConsumableItemData:
		#interact_ui.visible = true
		#item = item_entered

func _on_pickup_area_area_exited(_item: Area2D):
	interact_ui.visible = false

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact") and interact_ui.visible == true:
		#if inventory.add_item(item.item_data):
			#item.queue_free()
