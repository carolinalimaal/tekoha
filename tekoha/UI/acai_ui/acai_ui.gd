extends CanvasLayer

@onready var moedas: Label = $Moedas

func _ready() -> void:
	GlobalSignals.wallet_updated.connect(_on_wallet_updated)
	
func _on_wallet_updated(wallet: int):
	moedas.text = str(wallet)
