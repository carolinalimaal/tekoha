extends StaticBody2D

var openned: bool = false
@onready var item: ConsumableItemData = load("res://data/items/tambaqui_assado.tres")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_ui: CanvasLayer = $InteractionUI
@onready var interaction_container: MarginContainer = $InteractionUI/InteractionContainer
@onready var show_item_panel: Panel = $InteractionUI/ShowItemPanel
@onready var show_item_panel_label: Label = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/VBoxContainer/ShowItemLabel
@onready var item_hbox_cont: HBoxContainer = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer
@onready var item_image: TextureRect = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/TextureRect

# Reações do baú com a proximidade do player
func _on_player_interact_area_body_entered(body: Node2D) -> void:
	if body is Player and !openned:
		interact_ui.visible = true

func _on_player_interact_area_body_exited(body: Node2D) -> void:
	if body is Player:
		if openned:
			close_chest()
		else:
			interact_ui.visible = false

# Lógica de apertar o interact input dentro da área do baú
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and !openned:
		update_item_panel()
		open_chest()
	elif event.is_action_pressed("interact") and show_item_panel.visible == true and openned:
		close_chest()

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
		show_item_panel_label.text = "O BAÚ ESTÁ VAZIO"
		item_hbox_cont.visible = false
		
	elif verify_full_inventory():
		item_image.texture = null
		show_item_panel_label.text = "SEU INVENTÁRIO ESTÁ CHEIO"
		item_hbox_cont.visible = false
		
	elif item:
		item_image.texture = item.icon
		show_item_panel_label.text = "VOCÊ DESEJA PEGAR O ITEM\n" + item.name.to_upper() + "?"
		if !item_hbox_cont.visible:
			item_hbox_cont.visible = true

# Funções para abrir e fechar o baú e suas respectivas animações
func open_chest():
	openned = true
	sprite.play("bau_animation")
	interact_ui.visible = true
	interaction_container.visible = false
	show_item_panel.visible = true

func close_chest():
	show_item_panel.visible = false
	interact_ui.visible = false
	sprite.play_backwards("bau_animation")
	openned = false
	interaction_container.visible = true

# Função que verifica se o inventário está cheio
func verify_full_inventory() -> bool:
	return GlobalRefs.inventory._get_empty_item_slot() == null
