class_name ShopUI
extends Control

@export var item_row_scene: PackedScene

@export var items_stock: Array[ConsumableItemData]

var current_row_selected: ShopItemRow

@onready var item_list: VBoxContainer = $Panel/VBoxContainer/PanelContainer/ScrollContainer/MarginContainer/ItemList
@onready var navigation_legend: NavigationLegend = $Panel/VBoxContainer/NavigationLegend

func _ready() -> void:
	for i in items_stock:
		var item_row_instance: ShopItemRow = item_row_scene.instantiate()
		item_list.add_child(item_row_instance)
		item_row_instance.item_pressed.connect(_on_item_pressed)
		item_row_instance.setup_item(i)

func grab_initial_focus() -> void:
	_update_ui()
	item_list.get_child(0).grab_focus()

func close_ui() -> void:
	current_row_selected = null
	hide()

func cancel_action() -> void:
	UIManager.close_top_menu()

func _update_ui() -> void:
	var wallet = GameManager.current_save.wallet
	for row in item_list.get_children():
		if row is ShopItemRow:
			row.update_state(wallet >= row.item.price)

func _on_item_pressed(item_row_pressed: ShopItemRow) -> void:
	current_row_selected = item_row_pressed

	if GameManager.current_save.wallet < current_row_selected.item.price:
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_ERROR)
		GlobalSignals.hud_info.emit("Sem dinheiro suficiente!")
		return

	GlobalRefs.confirmation_popup.setup(
		"Deseja comprar " + current_row_selected.item.name + "?",
		null,
		true,
		"Comprar")

	UIManager.open_menu("confirmation")
	_connect_popup_signals()
	_set_slots_focus(false)

func _on_confirm_bought() -> void:
	if GlobalRefs.inventory._get_empty_item_slot() == null:
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_ERROR)
		GlobalSignals.hud_info.emit("Seu inventário já está cheio!")
		_close_popup()
		return

	var item = current_row_selected.item
	GameManager._remove_coin(item.price)
	GlobalRefs.inventory.add_item(item)
	_update_ui()
	_close_popup()

func _on_cancel_bought() -> void:
	_close_popup()

func _close_popup() -> void:
	_disconnect_popup_signals()
	_set_slots_focus(true)
	UIManager.close_top_menu()
	if current_row_selected:
		current_row_selected.grab_focus()
		current_row_selected = null

func _connect_popup_signals() -> void:
	if !GlobalRefs.confirmation_popup.confirmed.is_connected(_on_confirm_bought):
		GlobalRefs.confirmation_popup.confirmed.connect(_on_confirm_bought)
	if !GlobalRefs.confirmation_popup.cancelled.is_connected(_on_cancel_bought):
		GlobalRefs.confirmation_popup.cancelled.connect(_on_cancel_bought)

func _disconnect_popup_signals() -> void:
	if GlobalRefs.confirmation_popup.confirmed.is_connected(_on_confirm_bought):
		GlobalRefs.confirmation_popup.confirmed.disconnect(_on_confirm_bought)
	if GlobalRefs.confirmation_popup.cancelled.is_connected(_on_cancel_bought):
		GlobalRefs.confirmation_popup.cancelled.disconnect(_on_cancel_bought)

func _set_slots_focus(enable: bool) -> void:
	for row in item_list.get_children():
		if row is ShopItemRow:
			row.focus_mode = Control.FOCUS_ALL if enable else Control.FOCUS_NONE
