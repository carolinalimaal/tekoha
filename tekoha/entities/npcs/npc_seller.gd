extends NPC

@onready var shop_ui: ShopUI = $CanvasLayer/ShopUI

func _ready() -> void:
	super()
	UIManager.register_menu("shopping", shop_ui)

func _on_timeline_started() -> void:
	super()

func _on_timeline_ended() -> void:
	super()
	UIManager.open_menu("shopping")
