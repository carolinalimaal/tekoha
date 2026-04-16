extends Node

enum ItemType {
	COIN,
	MUIRAQUITA,
	FOOD
}

var main_scene: Node2D
#var ui_canvas_layer: CanvasLayer
var new_item_found_panel: NewItemFoundPanel
var confirmation_popup: ConfirmationPopup
var player: Player

var inventory: Inventory
