extends Node


var wallet: int = 0
var muiraquitas_collected: Dictionary = {}

func _ready() -> void:
	GlobalSignals.coin_collected.connect(_on_coin_collected)
	GlobalSignals.new_muiraquita_found.connect(_on_muiraquita_found)

func _on_coin_collected(value: int) -> void:
	_add_coin(value)

func _on_muiraquita_found(id: int) -> void:
	_register_muiraquita(id)

func _add_coin(value: int) -> void:
	wallet += value
	
	# TODO: adicionar som de coletar moeda
	
	GlobalSignals.wallet_updated.emit(wallet)

func _register_muiraquita(id: int) -> void:
	# Registrar no dicionario
	muiraquitas_collected[id] = true
	
	# TODO: adicionar som de encontrar muiraquita
	
	# Emitir sinal para mostrar UI
	GlobalSignals.muiraquita_updated.emit(id)
