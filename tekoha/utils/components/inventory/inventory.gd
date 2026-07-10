class_name Inventory
extends Node

signal updated_inventory

func _init() -> void:
	GlobalRefs.inventory = self

# Adiciona um item ao inventario
func add_item(item: ConsumableItemData) -> bool:
	# Pegar um slot vazio e, caso encontre um, adiciona o item a ele
	var slot: ItemSlot = _get_empty_item_slot()
	if !slot:
		return false
	slot.item = item
	# Emite sinais para atualizar a UI
	GlobalSignals.hud_info.emit(item.name + " adicionado ao inventário!")
	updated_inventory.emit()

	return true

# Remove um item do inventario
func remove_item_from_slot(index: int) -> void:
	# Verifica se o index é válido
	if index < 0 or index >= GameManager.current_save.inventory_slots.size():
		return
	# Pegar um slot pelo index e, caso contenha um item, limpa-lo
	var slot: ItemSlot = _get_slot_by_index(index)
	if slot.is_empty():
		return
	slot.clear()
	# Emite sinais para atualizar a UI
	updated_inventory.emit()

# Retorna um slot vazio
func _get_empty_item_slot() -> ItemSlot:
	for slot in GameManager.current_save.inventory_slots:
		if slot.is_empty():
			return slot
	return null

# Retorna um slot pelo index
func _get_slot_by_index(index: int) -> ItemSlot:
	# Verifica se o index é válido
	if index < 0 or index >= GameManager.current_save.inventory_slots.size():
		return null
	# Retorna o slot
	return GameManager.current_save.inventory_slots[index]
