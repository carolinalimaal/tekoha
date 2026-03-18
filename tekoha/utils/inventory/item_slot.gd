class_name ItemSlot
extends Resource

@export var item: ConsumableItemData
@export var slot_index: int

func _init(index: int = 0) -> void:
	slot_index = index

func is_empty() -> bool:
	return item == null

func clear() -> void:
	item = null
