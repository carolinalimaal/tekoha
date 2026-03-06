class_name Bau extends StaticBody2D

var openned: bool = false
var can_interact: bool = false
@export var item: ConsumableItemData
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_container: MarginContainer = $InteractionUI/InteractionContainer
@onready var show_item_panel: Panel = $InteractionUI/ShowItemPanel
@onready var show_item_panel_hbox_cont: HBoxContainer = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer
@onready var show_item_panel_label: Label = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/VBoxContainer/ShowItemLabel
@onready var item_hbox_cont: HBoxContainer = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer
@onready var item_image: TextureRect = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/TextureRect

func _ready() -> void:
	show_item_panel.visible = false
	interaction_container.visible = false

# Reações do baú com a proximidade do player
func _on_player_interact_area_body_entered(body: Node2D) -> void:
	if body is Player and !openned:
		interaction_container.visible = true
		can_interact = true

func _on_player_interact_area_body_exited(body: Node2D) -> void:
	if body is Player:
		interaction_container.visible = false
		can_interact = false

# Lógica de apertar o interact input dentro da área do baú
func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact"):
		if openned and get_tree().paused:
			close_chest()
		elif !openned and !get_tree().paused and can_interact:
			update_item_panel()
			open_chest()

# Verifica o aperto dos botões e as ações
func _on_accept_button_pressed() -> void:
	GlobalRefs.inventory.add_item(item)
	print("Item adicionado ao invenário!")
	item = null
	close_chest()

func _on_decline_button_pressed() -> void:
	close_chest()

# Altera o texto a ser mostrado para o player
func update_item_panel():
	if item == null:
		item_image.texture = null
		show_item_panel_label.text = "O BAÚ ESTÁ VAZIO."
		item_hbox_cont.visible = false
		show_item_panel_hbox_cont.alignment = BoxContainer.ALIGNMENT_BEGIN
	elif verify_full_inventory():
		item_image.texture = null
		show_item_panel_label.text = "SEU INVENTÁRIO ESTÁ CHEIO."
		item_hbox_cont.visible = false
		show_item_panel_hbox_cont.alignment = BoxContainer.ALIGNMENT_BEGIN
	elif item:
		item_image.texture = item.icon
		show_item_panel_label.text = "VOCÊ DESEJA PEGAR O ITEM\n" + item.name.to_upper() + "?"
		show_item_panel_hbox_cont.alignment = BoxContainer.ALIGNMENT_CENTER
		if !item_hbox_cont.visible:
			item_hbox_cont.visible = true

# Funções para abrir e fechar o baú e suas respectivas animações
func open_chest():
	get_tree().paused = true
	sprite.play("bau_animation")
	await sprite.animation_finished
	openned = true
	interaction_container.visible = false
	show_item_panel.visible = true

func close_chest():
	show_item_panel.visible = false
	interaction_container.visible = true
	get_tree().paused = false
	sprite.play_backwards("bau_animation")
	openned = false

# Função que verifica se o inventário está cheio
func verify_full_inventory() -> bool:
	return GlobalRefs.inventory._get_empty_item_slot() == null
