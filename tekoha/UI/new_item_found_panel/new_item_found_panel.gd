class_name NewItemFoundPanel
extends Panel

const HEART_SIZE: float = 4.0

@export var heart_icon: PackedScene

var coin_data: ItemData = load("res://data/items/coin.tres")
var muiraquita_data: ItemData = load("res://data/items/muiraquita.tres")

var is_showing: bool

@onready var item_icon: TextureRect = $Bg/MarginContainer/HBoxContainer/ItemIcon
@onready var item_name: Label = $Bg/MarginContainer/HBoxContainer/VBoxContainer/ItemName
@onready var hb_hearts_container: HBoxContainer = $Bg/MarginContainer/HBoxContainer/VBoxContainer/HBHeartsContainer
@onready var item_description: RichTextLabel = $Bg/MarginContainer/HBoxContainer/VBoxContainer/ItemDescription

func _ready() -> void:
	hide()

#func _unhandled_input(_event: InputEvent) -> void:
	#if InputManager.get_action_pressed("ui_accept") and is_showing:
		#var tween = create_tween()
		## Interpolação usando função seno para deixar mais suave
		#tween.set_trans(Tween.TRANS_SINE)
		## Fade-Out
		#tween.tween_property(self, "modulate:a", 0.0, 0.5)
		#await tween.finished
		#hide()
		#get_tree().paused = false
		#is_showing = false
#
#func show_panel(item_type: GlobalRefs.ItemType, item_data: ConsumableItemData) -> void:
	#_load_item_data(item_type, item_data)
	#modulate.a = 0.0
	#show()
	#get_tree().paused = true
	#is_showing = true
	#var tween = create_tween()
	## Interpolação usando função seno para deixar mais suave
	#tween.set_trans(Tween.TRANS_SINE)
	## Fade-In
	#tween.tween_property(self, "modulate:a", 1.0, 0.5)

func show_panel(item_type: GlobalRefs.ItemType, item_data: ConsumableItemData) -> void:
	_load_item_data(item_type, item_data)
	modulate.a = 0.0
	show()
	is_showing = true
	var tween = create_tween()
	# Interpolação usando função seno para deixar mais suave
	tween.set_trans(Tween.TRANS_SINE)
	# Fade-In
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	# Espera 2s
	tween.tween_interval(2.5)
	# Fade-Out
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	hide()
	is_showing = false

func _load_item_data(item_type: GlobalRefs.ItemType, item_data: ConsumableItemData) -> void:
	match item_type:
		GlobalRefs.ItemType.COIN:
			item_icon.texture = coin_data.icon
			item_name.text = coin_data.name
			item_description.text = coin_data.description
			hb_hearts_container.hide()
		GlobalRefs.ItemType.MUIRAQUITA:
			item_icon.texture = muiraquita_data.icon
			item_name.text = muiraquita_data.name
			item_description.text = muiraquita_data.description
			hb_hearts_container.hide()
		GlobalRefs.ItemType.FOOD:
			item_icon.texture = item_data.icon
			item_name.text = item_data.name
			item_description.text = item_data.description
			hb_hearts_container.show()
			calculate_hearts(item_data.health_gain)

func calculate_hearts(health_gain: int) -> void:
	var hearts = hb_hearts_container.get_children()
	for heart in hearts:
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
