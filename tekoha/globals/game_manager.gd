extends Node


var wallet: int = 0

func _ready() -> void:
	GlobalSignals.coin_collected.connect(_on_coin_collected)

func _on_coin_collected(value: int) -> void:
	add_coin(value)

func add_coin(value: int) -> void:
	wallet += value
	GlobalSignals.wallet_updated.emit(wallet)
