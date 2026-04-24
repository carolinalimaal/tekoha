class_name InventoryUI
extends Control

var slots: Array
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
	
	slots = _slots_grid.get_children()
	
	# Conectar sinais dos slots
	for slot in slots:
		if slot is InventorySlotUI:
			slot.slot_clicked.connect(_on_slot_clicked)
			slot.slot_highlighted.connect(_on_slot_highlighted)
			slot.slot_unhighlighted.connect(_on_slot_unhighlighted)

func grab_initial_focus() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.OPEN_MENU)
	_update_ui()
	for slot in slots:
		if slot is InventorySlotUI and slot.item_button.focus_mode != Control.FOCUS_NONE:
			slot.item_button.grab_focus()
			break

func close_ui() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.CLOSE_MENU)
	hide()

func _update_ui() -> void:
	# Referencia ao inventario
	var inventory_slots = GameManager.current_save.inventory_slots
	
	# Set dos itens do inventario aos slots da UI
	for i in range(slots.size()):
		if slots[i] is InventorySlotUI:
			if i < inventory_slots.size():
				slots[i].set_item_slot(inventory_slots[i])
			else:
				slots[i].set_item_slot(null)


# --- LOGICA DO POPUP ---
func _on_slot_clicked(slot: InventorySlotUI) -> void:
	_current_slot_selected = slot
	GlobalRefs.confirmation_popup.setup(
		"Deseja usar " + slot.item_slot.item.name + "?", 
		null, 
		true,
		"Usar")
	
	UIManager.open_menu("confirmation")
	_connect_signals()
	# Bloquear foco nos slots quando o popup estiver aberto
	for s in slots:
		if s is InventorySlotUI:
			s.item_button.focus_mode = Control.FOCUS_NONE

func _on_confirm_use() -> void:
	var item_slot = _current_slot_selected.item_slot
	if _current_slot_selected and item_slot and !item_slot.is_empty():
		#GlobalRefs.player.health_component.heal(item_slot.item.health_gain)
		GlobalRefs.player.heal(item_slot.item.health_gain)
		
		GlobalRefs.inventory.remove_item_from_slot(item_slot.slot_index)
	
	_close_popup()

func _on_cancel_use() -> void:
	_close_popup()

func _close_popup() -> void:
	_disconnect_signals()
	UIManager.close_top_menu()
	
	# Permitir foco nos slots quando o popup estiver fechado
	for s in slots:
		if s is InventorySlotUI and s.item_slot.item:
			s.item_button.focus_mode = Control.FOCUS_ALL
	
	# Focar no item que foi clicado
	if _current_slot_selected:
		_current_slot_selected.item_button.grab_focus()
	
	_current_slot_selected = null

func cancel_action() -> void:
	_close_popup()

func _connect_signals() -> void:
	if !GlobalRefs.confirmation_popup.confirmed.is_connected(_on_confirm_use):
		GlobalRefs.confirmation_popup.confirmed.connect(_on_confirm_use)
	if !GlobalRefs.confirmation_popup.cancelled.is_connected(_on_cancel_use):
		GlobalRefs.confirmation_popup.cancelled.connect(_on_cancel_use)

func _disconnect_signals() -> void:
	if GlobalRefs.confirmation_popup.confirmed.is_connected(_on_confirm_use):
		GlobalRefs.confirmation_popup.confirmed.disconnect(_on_confirm_use)
	if GlobalRefs.confirmation_popup.cancelled.is_connected(_on_cancel_use):
		GlobalRefs.confirmation_popup.cancelled.disconnect(_on_cancel_use)


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
