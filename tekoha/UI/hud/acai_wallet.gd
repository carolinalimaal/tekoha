extends PanelContainer

@onready var coin_label: Label = $HBoxContainer/CoinLabel

func _ready() -> void:
	GlobalSignals.wallet_updated.connect(_on_wallet_updated)
	
	# Carregar dados do save
	if GameManager.current_save:
		_on_wallet_updated(GameManager.current_save.wallet)
	
func _on_wallet_updated(wallet: int):
	coin_label.text = str(wallet)
