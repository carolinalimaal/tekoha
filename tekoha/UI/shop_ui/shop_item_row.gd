class_name ShopItemRow
extends Button

signal item_pressed(item_row: ShopItemRow)

var item: ConsumableItemData

@onready var item_icon: TextureRect = $MarginContainer/HBoxContainer/ItemIcon
@onready var item_name: Label = $MarginContainer/HBoxContainer/ItemInfo/ItemName
@onready var heart_container: HBoxContainer = $MarginContainer/HBoxContainer/ItemInfo/HeartContainer
@onready var price_label: Label = $MarginContainer/HBoxContainer/PriceLabel

func _ready() -> void:
	pressed.connect(_on_item_button_pressed)

func setup_item(item_data: ConsumableItemData) -> void:
	if item_data:
		item = item_data
		item_icon.texture = item.icon
		item_name.text = item.name
		heart_container.update_hearts(item.health_gain)
		price_label.text = str(item.price)

func update_state(can_afford: bool) -> void:
	if can_afford:
		price_label.remove_theme_color_override("font_color")
	else:
		price_label.add_theme_color_override("font_color", Color("#963638"))

func _on_item_button_pressed() -> void:
	item_pressed.emit(self)
