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
var options_menu: OptionsMenu
var hud: Control
var player: Player

var player_camera: PlayerCamera

var inventory: Inventory

var game_afternoon_filter: DirectionalLight2D
var game_nightfall_filter: DirectionalLight2D
