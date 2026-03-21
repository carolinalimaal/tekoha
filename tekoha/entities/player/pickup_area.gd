class_name PickupArea extends Area2D

var inventory: Inventory

func _ready() -> void:
	area_entered.connect(_on_pickup_area_area_entered)
	
	inventory = GlobalRefs.inventory

func _on_pickup_area_area_entered(item_entered: Area2D):
	if item_entered is Coin or item_entered is Muiraquita:
		item_entered.collect()
