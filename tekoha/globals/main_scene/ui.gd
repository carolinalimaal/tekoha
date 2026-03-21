extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var game_over_menu: Control = $GameOverMenu
@onready var inventory_ui: InventoryUI = $InventoryUi
@onready var heart_ui: CanvasLayer = $HeartUI
@onready var acai_ui: CanvasLayer = $AcaiUI
@onready var new_item_found_panel: NewItemFoundPanel = $NewItemFoundPanel


func _ready() -> void:
	GlobalRefs.ui_canvas_layer = self
	GlobalRefs.new_item_found_panel = new_item_found_panel
