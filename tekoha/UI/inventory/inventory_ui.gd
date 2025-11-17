class_name InventoryUI
extends Control

var current_slot_selected: InventorySlotUI
# TODO: Verificar se essa variavel ficara aqui ou em um script global
var _is_open: bool = false

@onready var slots = $VBoxContainer/TextureRect/HBoxContainer/SlotsGrid.get_children()
@onready var description_box: VBoxContainer = $VBoxContainer/TextureRect/HBoxContainer/MarginContainer/DescriptionBox
@onready var item_name: Label = $VBoxContainer/TextureRect/HBoxContainer/MarginContainer/DescriptionBox/ItemName
@onready var item_effect: Label = $VBoxContainer/TextureRect/HBoxContainer/MarginContainer/DescriptionBox/ItemEffect
@onready var item_description: RichTextLabel = $VBoxContainer/TextureRect/HBoxContainer/MarginContainer/DescriptionBox/ItemDescription

func _ready() -> void:
	# Conectar sinal para manter a UI do inventario atualizada
	GlobalSignals.updated_inventory.connect(_update_ui)
	# Conectar sinais dos slots
	for i in len(slots):
		if slots[i] is InventorySlotUI:
			slots[i].show_description.connect(_on_show_item_description)
			slots[i].hide_description.connect(_on_hide_item_description)
			slots[i].slot_selected.connect(_on_slot_selected)
			slots[i].item_used.connect(_on_item_used)
	
	# Inventario inicia fechado
	_close()

# Gerenciar os inputs para abri ou fechar o inventário
func _unhandled_input(_event: InputEvent) -> void:
	if GlobalRefs.input_manager.get_action_pressed("inventory"):
		if _is_open and get_tree().paused:
			_close()
		elif !_is_open and !get_tree().paused:
			_open()

func _close() -> void:
	self.visible = false
	_is_open = false
	get_tree().paused = false
	# Reativa todos os slots e reseta o current_slot_selected
	_deselect_all_slots()
	# Reseta o painel de informacoes do item
	_on_hide_item_description()

func _open() -> void:
	self.visible = true
	_is_open = true
	get_tree().paused = true
	_update_ui()

# Atualiza a UI do inventário
func _update_ui() -> void:
	for i in len(slots):
		if GlobalRefs.inventory.inventory_slots[i].item:
			slots[i].set_item_slot(GlobalRefs.inventory.inventory_slots[i])
		else: 
			slots[i].set_item_slot(null)

# Atribui as informações do item no painel
func _on_show_item_description(item: ConsumableItemData) -> void:
	description_box.visible = true
	item_name.text = item.name
	item_effect.text = str(item.health_gain)
	item_description.text = item.description

# Reseta as informações do item no painel
func _on_hide_item_description() -> void:
	description_box.visible = false
	item_name.text = ""
	item_effect.text = ""
	item_description.text = ""

# Salva o current_slot_selected e desabilita os demais
func _on_slot_selected(slot: InventorySlotUI) -> void:
	for s in slots:
		if s is InventorySlotUI and s != slot:
			s.set_disable(true)

# Reabilita os slots e reseta o current_slot_selected
func _deselect_all_slots() -> void:
	for s in slots:
		if s is InventorySlotUI:
			s.set_disable(false)
			s.hide_options_menu()
	current_slot_selected = null

# Usa o item e o remove do inventário
func _on_item_used(item_slot: ItemSlot) -> void:
	if item_slot and !item_slot.is_empty():
		GlobalRefs.inventory.remove_item_from_slot(item_slot.slot_index)
		# TODO: Funcionalidade de usar o item
		
		# Reativa todos os slots e reseta o current_slot_selected
		_deselect_all_slots()
		# Reseta o painel de informacoes do item
		_on_hide_item_description()
