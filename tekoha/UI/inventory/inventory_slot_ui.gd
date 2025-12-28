class_name InventorySlotUI
extends Control

signal show_description(item)
signal hide_description()
signal slot_selected(slot)
signal item_used(item_slot)

var item_slot: ItemSlot
var inventory_ui: InventoryUI
var _is_disable: bool = false

@onready var item_icon: TextureRect = $ItemIcon
@onready var item_button: Button = $ItemButton
@onready var options_menu: Panel = $OptionsMenu
@onready var use_button: Button = $OptionsMenu/VBoxContainer/UseButton
@onready var cancel_button: Button = $OptionsMenu/VBoxContainer/CancelButton


func _ready() -> void:
	# Conectar sinais aos botões
	item_button.mouse_entered.connect(_on_show_description)
	item_button.mouse_exited.connect(_on_hide_description)
	item_button.pressed.connect(_on_slot_pressed)
	use_button.pressed.connect(_on_use_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	# Menu de opçoes inicia escondido
	hide_options_menu()

func set_item_slot (_item_slot: ItemSlot):
	# Atribuir o item ao slot
	self.item_slot = _item_slot
	# Atribuir o icone ao seu slot
	if item_slot and item_slot.item.icon:
		item_icon.texture = item_slot.item.icon
		item_button.disabled = false
	else:
		item_icon.texture = null
		item_button.disabled = true

# Mudar o estado do botão entre habilitado e desabilitado
func set_disable(disabled: bool):
	_is_disable = disabled
	item_button.disabled = disabled
	if disabled and options_menu.visible:
		hide_options_menu()

# Esconder o menu de opções
func hide_options_menu():
	options_menu.visible = false

# Mostrar o menu de opções
func show_options_menu():
	# Caso o slot esteja habilidado e exista item nele, mostra o menu
	if !_is_disable and item_slot and !item_slot.is_empty():
		options_menu.position = Vector2(size.x/2, size.y/2)
		options_menu.visible = true
		slot_selected.emit(self)

# Esconder as informações do item se ele não for o item selecionado
func _on_hide_description() -> void:
	if !_is_disable and item_slot and !item_slot.is_empty() and inventory_ui.current_slot_selected != self:
		# Emite sinal para esconder as informações do item
		hide_description.emit()

# Mostrar as informações do item 
func _on_show_description() -> void:
	if !_is_disable and item_slot and !item_slot.is_empty():
		# Emite sinal para mostrar as informações do item
		show_description.emit(item_slot.item)

# Mostrar o menu de opções ao clicar no item
func _on_slot_pressed() -> void:
	if !_is_disable and item_slot and !item_slot.is_empty():
		show_options_menu()

# Usar o item
func _on_use_pressed():
	hide_options_menu()
	if item_slot and item_slot and !item_slot.is_empty():
		item_used.emit(item_slot)

# Cancelar a seleção do slot
func _on_cancel_pressed():
	hide_options_menu()
	# Emite sinal para esconder as informações do item
	hide_description.emit()
