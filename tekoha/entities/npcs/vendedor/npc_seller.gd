extends NPC

@onready var shop_ui: ShopUI = $CanvasLayer/ShopUI

var _interacted: bool = false

func _ready() -> void:
	super()
	UIManager.register_menu("shopping", shop_ui)

func interact() -> void:
	_interacted = true
	super()

func _on_timeline_started() -> void:
	super()

func _on_timeline_ended() -> void:
	super()
	if _interacted:
		_interacted = false
		UIManager.open_menu("shopping")
