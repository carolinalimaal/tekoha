class_name InventoryUI
extends Control

const HEART_SIZE: float = 4.0

@export var heart_icon: PackedScene

var slots: Array
var _is_open: bool = false
var _current_slot_highlighted: InventorySlotUI = null
var _current_slot_selected: InventorySlotUI = null

@onready var _slots_grid: GridContainer = $VBoxContainer/BgInventory/HBoxContainer/SlotsGrid
@onready var _description_box: VBoxContainer = $VBoxContainer/BgInventory/HBoxContainer/MarginContainer/DescriptionBox
@onready var _item_name: Label = $VBoxContainer/BgInventory/HBoxContainer/MarginContainer/DescriptionBox/ItemName
@onready var hb_hearts_container: HBoxContainer = $VBoxContainer/BgInventory/HBoxContainer/MarginContainer/DescriptionBox/HBHeartsContainer
@onready var _item_description: RichTextLabel = $VBoxContainer/BgInventory/HBoxContainer/MarginContainer/DescriptionBox/ItemDescription

@onready var _confirmation_popup: Panel = $ConfirmationPopup
@onready var _popup_label: Label = $ConfirmationPopup/Bg/MarginContainer/VBoxContainer/PopupLabel
@onready var _confirm_button: DefaultButton = $ConfirmationPopup/Bg/MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton
@onready var _cancel_button: DefaultButton = $ConfirmationPopup/Bg/MarginContainer/VBoxContainer/HBoxContainer/CancelButton


func _ready() -> void:
	# Conectar sinal para atualizar o inventario
	GlobalRefs.inventory.updated_inventory.connect(_update_ui)
	
	# Conectar sinais de click dos botoes do ConfirmationPopup
	_confirm_button.pressed.connect(_on_confirm_use)
	_cancel_button.pressed.connect(_on_cancel_use)
	
	_confirmation_popup.hide()
	
	slots = _slots_grid.get_children()
	
	# Conectar sinais dos slots
	for slot in slots:
		if slot is InventorySlotUI:
			slot.slot_clicked.connect(_on_slot_clicked)
			slot.slot_highlighted.connect(_on_slot_highlighted)
			slot.slot_unhighlighted.connect(_on_slot_unhighlighted)

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("inventory"):
		if _is_open and get_tree().paused:
			_close()
		elif !_is_open and !get_tree().paused:
			_open()

func _open() -> void:
	_is_open = true
	show()
	get_tree().paused = true
	_update_ui() # Atualiza a UI ao abrir o inventario
	slots[0].item_button.grab_focus() # Primeiro item em foco

func _close() -> void:
	_is_open = false
	hide()
	get_tree().paused = false
	_close_popup() # Fechar popup caso feche o inventario

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
	
	_confirmation_popup.show()
	_popup_label.text = "Deseja usar " + slot.item_slot.item.name + "?"
	
	# Bloquear foco nos slots quando o popup estiver aberto
	for s in slots:
		if s is InventorySlotUI:
			s.item_button.focus_mode = Control.FOCUS_NONE
	
	_confirm_button.grab_focus() # Focar no botao de usar

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
	_confirmation_popup.hide()
	
	# Permitir foco nos slots quando o popup estiver fechado
	for s in slots:
		if s is InventorySlotUI:
			s.item_button.focus_mode = Control.FOCUS_ALL
	
	# Focar no item que foi clicado
	if _current_slot_selected:
		_current_slot_selected.item_button.grab_focus()
	
	_current_slot_selected = null


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
	calculate_hearts(item.health_gain)

func _clear_description() -> void:
	_description_box.hide()
	_item_name.text = ""
	_item_description.text = ""
	calculate_hearts(0)

func calculate_hearts(health_gain: int) -> void:
	var hearts = hb_hearts_container.get_children()
	for heart in hearts:
		hb_hearts_container.remove_child(heart)
		heart.queue_free()
	var total_hearts = ceil(health_gain / HEART_SIZE)
	
	for i in range(total_hearts):
		var heart_instance = heart_icon.instantiate()
		hb_hearts_container.add_child(heart_instance)
		
	hearts = hb_hearts_container.get_children()
	for heart in hearts:
		var value_to_display = clampi(health_gain, 0, 4)
		heart.update_sprite(value_to_display)
		health_gain -= 4
