class_name NewItemFoundPanel
extends Panel

var coin_data: ItemData = load("res://data/items/coin.tres")
var muiraquita_data: ItemData = load("res://data/items/muiraquita.tres")

var is_showing: bool

@onready var item_icon: TextureRect = $Bg/MarginContainer/HBoxContainer/ItemIcon
@onready var item_name: Label = $Bg/MarginContainer/HBoxContainer/VBoxContainer/ItemName
@onready var heart_container: HBoxContainer = $Bg/MarginContainer/HBoxContainer/VBoxContainer/HeartContainer
@onready var item_description: RichTextLabel = $Bg/MarginContainer/HBoxContainer/VBoxContainer/ItemDescription

func _ready() -> void:
	hide()

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("ui_accept") and is_showing:
		get_viewport().set_input_as_handled() # Engolimos o input!
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		await tween.finished
		
		is_showing = false
		UIManager.close_top_menu()

func show_panel(item_type: GlobalRefs.ItemType, item_data: ConsumableItemData) -> void:
	_load_item_data(item_type, item_data)
	modulate.a = 0.0
	
	UIManager.open_menu("item_found")
	
	is_showing = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func _load_item_data(item_type: GlobalRefs.ItemType, item_data: ConsumableItemData) -> void:
	match item_type:
		GlobalRefs.ItemType.COIN:
			item_icon.texture = coin_data.icon
			item_name.text = coin_data.name
			item_description.text = coin_data.description
			heart_container.hide()
		GlobalRefs.ItemType.MUIRAQUITA:
			item_icon.texture = muiraquita_data.icon
			item_name.text = muiraquita_data.name
			item_description.text = muiraquita_data.description
			heart_container.hide()
		GlobalRefs.ItemType.FOOD:
			item_icon.texture = item_data.icon
			item_name.text = item_data.name
			item_description.text = item_data.description
			heart_container.show()
			heart_container.update_hearts(item_data.health_gain)
