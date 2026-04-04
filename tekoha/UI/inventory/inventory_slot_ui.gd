class_name InventorySlotUI
extends Control

signal slot_clicked(slot: InventorySlotUI)
signal slot_highlighted(slot: InventorySlotUI)
signal slot_unhighlighted(slot: InventorySlotUI)

var item_slot: ItemSlot

@onready var item_icon: TextureRect = $ItemIcon
@onready var item_button: DefaultButton = $ItemButton

func _ready() -> void:
	# Sinais para interacao de click, hover e focus
	item_button.pressed.connect(_on_pressed)
	
	item_button.mouse_entered.connect(_on_mouse_entered)
	item_button.mouse_exited.connect(_on_mouse_exited)
	
	item_button.focus_entered.connect(_on_focus_entered)
	item_button.focus_exited.connect(_on_focus_exited)

func set_item_slot(_item_slot: ItemSlot) -> void:
	item_slot = _item_slot
	# Atribuir icone ao slot
	if item_slot and item_slot.item:
		item_icon.texture = item_slot.item.icon
		item_icon.visible = true
		item_button.disabled = false
	else:
		item_icon.texture = null
		item_icon.visible = false
		item_button.disabled = true

# --- METODOS DOS SINAIS ---

func _on_pressed() -> void:
	if item_slot and item_slot.item:
		slot_clicked.emit(self)

func _on_mouse_entered() -> void:
	if item_slot and item_slot.item:
		slot_highlighted.emit(self)

func _on_mouse_exited() -> void:
	if !item_button.has_focus():
		slot_unhighlighted.emit(self)

func _on_focus_entered() -> void:
	if item_slot and item_slot.item:
		slot_highlighted.emit(self)

func _on_focus_exited() -> void:
	if !item_button.is_hovered():
		slot_unhighlighted.emit(self)
