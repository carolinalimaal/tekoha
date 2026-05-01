class_name InventoryUI
extends Control

var slots: Array[InventorySlotUI] = []
var _current_slot_highlighted: InventorySlotUI = null
var _current_slot_selected: InventorySlotUI = null

@onready var _slots_grid: GridContainer = $VBoxContainer/BgInventory/HBoxContainer/SlotsGrid
@onready var _description_box: VBoxContainer = $VBoxContainer/BgInventory/HBoxContainer/MarginContainer/DescriptionBox
@onready var _item_name: Label = $VBoxContainer/BgInventory/HBoxContainer/MarginContainer/DescriptionBox/ItemName
@onready var _heart_container: HBoxContainer = $VBoxContainer/BgInventory/HBoxContainer/MarginContainer/DescriptionBox/HeartContainer
@onready var _item_description: RichTextLabel = $VBoxContainer/BgInventory/HBoxContainer/MarginContainer/DescriptionBox/ItemDescription


func _ready() -> void:
	# Conectar sinal para atualizar o inventario
	GlobalRefs.inventory.updated_inventory.connect(_update_ui)
	
	for child in _slots_grid.get_children():
		if child is InventorySlotUI:
			slots.append(child)
			child.slot_clicked.connect(_on_slot_clicked)
			child.slot_highlighted.connect(_on_slot_highlighted)
			child.slot_unhighlighted.connect(_on_slot_unhighlighted)

func grab_initial_focus() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.OPEN_MENU)
	_update_ui()
	
	for slot in slots:
		if slot.item_button.focus_mode != Control.FOCUS_NONE:
			slot.item_button.grab_focus()
			return

func close_ui() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.CLOSE_MENU)
	hide()

func cancel_action() -> void:
	UIManager.close_top_menu()

func _update_ui() -> void:
	# Referencia ao inventario
	var inventory_slots = GameManager.current_save.inventory_slots
	
	# Set dos itens do inventario aos slots da UI
	for i in range(slots.size()):
		var item_data = inventory_slots[i] if i < inventory_slots.size() else null
		slots[i].set_item_slot(item_data)


# --- LOGICA DO POPUP ---
func _on_slot_clicked(slot: InventorySlotUI) -> void:
	_current_slot_selected = slot
	GlobalRefs.confirmation_popup.setup(
		"Deseja usar " + slot.item_slot.item.name + "?", 
		null, 
		true,
		"Usar")
	
	UIManager.open_menu("confirmation")
	_connect_popup_signals()
	# Bloquear foco nos slots quando o popup estiver aberto
	_set_slots_focus(false)

func _on_confirm_use() -> void:
	var item_slot = _current_slot_selected.item_slot
	if item_slot and !item_slot.is_empty():
		GlobalRefs.player.heal(item_slot.item.health_gain)
		GlobalRefs.inventory.remove_item_from_slot(item_slot.slot_index)
	
	_close_popup()

func _on_cancel_use() -> void:
	_close_popup()

func _close_popup() -> void:
	_disconnect_popup_signals()
	# Permitir foco nos slots quando o popup estiver fechado
	_set_slots_focus(true)
	UIManager.close_top_menu()
	
	# Focar no item que foi clicado
	if _current_slot_selected:
		_current_slot_selected.item_button.grab_focus()
		_current_slot_selected = null

func _connect_popup_signals() -> void:
	var popup = GlobalRefs.confirmation_popup
	if not popup.confirmed.is_connected(_on_confirm_use):
		popup.confirmed.connect(_on_confirm_use)
	if not popup.cancelled.is_connected(_on_cancel_use):
		popup.cancelled.connect(_on_cancel_use)

func _disconnect_popup_signals() -> void:
	var popup = GlobalRefs.confirmation_popup
	if popup.confirmed.is_connected(_on_confirm_use):
		popup.confirmed.disconnect(_on_confirm_use)
	if popup.cancelled.is_connected(_on_cancel_use):
		popup.cancelled.disconnect(_on_cancel_use)

func _set_slots_focus(enable: bool) -> void:
	for slot in slots:
		if enable and slot.item_slot and slot.item_slot.item:
			slot.item_button.focus_mode = Control.FOCUS_ALL
		else:
			slot.item_button.focus_mode = Control.FOCUS_NONE

# --- LOGICA DE DESCRICAO ---
func _on_slot_highlighted(slot: InventorySlotUI) -> void:
	if slot.item_slot and slot.item_slot.item:
		_current_slot_highlighted = slot
		_show_description(slot.item_slot.item)

func _on_slot_unhighlighted(slot: InventorySlotUI) -> void:
	if slot == _current_slot_highlighted:
		_current_slot_highlighted = null
		_clear_description()

func _show_description(item: ConsumableItemData) -> void:
	_description_box.show()
	_item_name.text = item.name
	_item_description.text = item.description
	_heart_container.update_hearts(item.health_gain)

func _clear_description() -> void:
	_description_box.hide()
	_item_name.text = ""
	_item_description.text = ""
	_heart_container.update_hearts(0)
