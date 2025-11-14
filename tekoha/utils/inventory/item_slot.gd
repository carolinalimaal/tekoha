class_name ItemSlot
extends RefCounted

var item: ConsumableItemData
var slot_index: int

func _init(index: int) -> void:
	slot_index = index

func is_empty() -> bool:
	return item == null

func clear() -> void:
	item = null
