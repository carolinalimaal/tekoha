extends Node

@onready var pause_menu: Control = $MenuLayer/PauseMenu
@onready var game_over_menu: Control = $MenuLayer/GameOverMenu
@onready var inventory_ui: InventoryUI = $MenuLayer/InventoryUi
@onready var new_item_found_panel: NewItemFoundPanel = $MenuLayer/NewItemFoundPanel
@onready var confirmation_popup: ConfirmationPopup = $MenuLayer/ConfirmationPopup

@onready var hud: Control = $HUDLayer/HUD

func _ready() -> void:
	# Atualiza as referências globais
	GlobalRefs.new_item_found_panel = new_item_found_panel
	GlobalRefs.confirmation_popup = confirmation_popup
	GlobalRefs.hud = hud
	# Esconder a HUD durante diálogos
	DialogueManager.dialogue_started.connect(hud.hide)
	DialogueManager.dialogue_ended.connect(hud.show)
	
	UIManager.register_menu("pause", pause_menu)
	UIManager.register_menu("game_over", game_over_menu)
	UIManager.register_menu("inventory", inventory_ui)
	UIManager.register_menu("item_found", new_item_found_panel)
	UIManager.register_menu("confirmation", confirmation_popup)

func _unhandled_input(_event: InputEvent) -> void:
	if InputManager.get_action_pressed("ui_cancel"):
		if !UIManager.menu_stack.is_empty():
			get_viewport().set_input_as_handled()
			var top_menu = UIManager.menu_stack.back()
			if top_menu.has_method("cancel_action"):
				top_menu.cancel_action()
			else:
				UIManager.close_top_menu()
			return
	# Abre ou fecha o Pause
	if InputManager.get_action_pressed("pause"):
		if UIManager.menu_stack.is_empty() and not game_over_menu.visible:
			UIManager.open_menu("pause")
		elif UIManager.menu_stack.back() == pause_menu:
			UIManager.close_top_menu()
	
	if UIManager.is_interact_ui_open:
		return
		
	# Abre ou fecha o Inventário
	if InputManager.get_action_pressed("inventory"):
		if UIManager.menu_stack.is_empty():
			UIManager.open_menu("inventory")
		elif UIManager.menu_stack.back() == inventory_ui:
			UIManager.close_top_menu()
