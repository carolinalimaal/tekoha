extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var game_over_menu: Control = $GameOverMenu
@onready var inventory_ui: InventoryUI = $InventoryUi
@onready var hud: Control = $HUD
@onready var new_item_found_panel: NewItemFoundPanel = $NewItemFoundPanel


func _ready() -> void:
	GlobalRefs.ui_canvas_layer = self
	GlobalRefs.new_item_found_panel = new_item_found_panel
	
	DialogueControl.dialogue_started.connect(hud.hide)
	DialogueControl.dialogue_ended.connect(hud.show)
	
