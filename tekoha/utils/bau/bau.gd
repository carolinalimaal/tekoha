class_name Bau extends StaticBody2D

@export var id: int
@export var item: ConsumableItemData

var is_showing: bool = false
var can_interact: bool = false

@onready var player_interact_area: Area2D = $PlayerInteractArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_container: MarginContainer = $InteractionUI/InteractionContainer
@onready var show_item_panel: Panel = $InteractionUI/ShowItemPanel
@onready var show_item_label: Label = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/VBoxContainer/ShowItemLabel
@onready var item_image: TextureRect = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/ItemImage

@onready var buttons_container: HBoxContainer = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer
@onready var accept_button: DefaultButton = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/AcceptButton
@onready var decline_button: DefaultButton = $InteractionUI/ShowItemPanel/Bg/MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/DeclineButton


func _ready() -> void:
	player_interact_area.body_entered.connect(_on_player_interact_area_body_entered)
	player_interact_area.body_exited.connect(_on_player_interact_area_body_exited)
	
	accept_button.pressed.connect(_on_accept_button_pressed)
	decline_button.pressed.connect(_on_decline_button_pressed)
	
	show_item_panel.hide()
	interaction_container.hide()
	
	if GameManager.current_save.opened_chests.has(id):
		item = null

# Lógica de apertar o interact input dentro da área do baú
func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("interact"):
		if is_showing and get_tree().paused:
			close_chest()
		elif !is_showing and !get_tree().paused and can_interact:
			update_item_panel()
			open_chest()

# Reações do baú com a proximidade do player
func _on_player_interact_area_body_entered(body: Node2D) -> void:
	if body is Player and !is_showing:
		interaction_container.show()
		can_interact = true

func _on_player_interact_area_body_exited(body: Node2D) -> void:
	if body is Player:
		interaction_container.hide()
		can_interact = false

# Verifica o aperto dos botões e as ações
func _on_accept_button_pressed() -> void:
	GlobalRefs.inventory.add_item(item)
	# Registra o bau aberto no current_save
	GameManager.current_save.opened_chests[id] = true
	print("Item adicionado ao inventário!")
	
	var is_new_item = !GameManager.current_save.known_items.has(item.name)
	var _item = item
	
	item = null
	close_chest()
	
	if is_new_item:
		GameManager.current_save.known_items[_item.name] = true
		GlobalRefs.new_item_found_panel.show_panel(GlobalRefs.ItemType.FOOD, _item)

func _on_decline_button_pressed() -> void:
	close_chest()

# Altera o texto a ser mostrado para o player
func update_item_panel():
	if item == null:
		item_image.texture = null
		item_image.hide()
		show_item_label.text = "O BAÚ ESTÁ VAZIO."
		buttons_container.hide()
	elif verify_full_inventory():
		item_image.texture = null
		item_image.hide()
		show_item_label.text = "SEU INVENTÁRIO ESTÁ CHEIO."
		buttons_container.hide()
	elif item:
		item_image.texture = item.icon
		if !GameManager.current_save.known_items.has(item.name):
			show_item_label.text = "??? ENCONTRADO!"
		else:
			show_item_label.text = item.name.to_upper() + " ENCONTRADO!"
		if !buttons_container.visible:
			buttons_container.show()

# Funções para abrir e fechar o baú e suas respectivas animações
func open_chest():
	get_tree().paused = true
	sprite.play("bau_animation")
	await sprite.animation_finished
	is_showing = true
	interaction_container.hide()
	show_item_panel.show()

func close_chest():
	get_tree().paused = false
	sprite.play_backwards("bau_animation")
	is_showing = false
	interaction_container.show()
	show_item_panel.hide()

# Função que verifica se o inventário está cheio
func verify_full_inventory() -> bool:
	return GlobalRefs.inventory._get_empty_item_slot() == null
