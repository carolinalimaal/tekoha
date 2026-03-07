extends CanvasLayer

@onready var moedas: Label = $Moedas

func _ready() -> void:
	GlobalSignals.wallet_updated.connect(_on_wallet_updated)
	
	# Carregar dados do save
	if GameManager.current_save:
		_on_wallet_updated(GameManager.current_save.wallet)
	
func _on_wallet_updated(wallet: int):
	moedas.text = str(wallet)
