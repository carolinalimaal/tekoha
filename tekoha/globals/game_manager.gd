extends Node

var current_save: SaveData

func _ready() -> void:
	GlobalSignals.coin_collected.connect(_on_coin_collected)
	GlobalSignals.new_muiraquita_found.connect(_on_muiraquita_found)
	
	# Criar objeto Inventory em GlobalRefs
	GlobalRefs.inventory = Inventory.new()

func _on_coin_collected(value: int) -> void:
	_add_coin(value)

func _on_muiraquita_found(id: int) -> void:
	_register_muiraquita(id)

func _add_coin(value: int) -> void:
	current_save.wallet += value
	
	# TODO: adicionar som de coletar moeda
	
	GlobalSignals.wallet_updated.emit(current_save.wallet)

func _register_muiraquita(id: int) -> void:
	# Registrar no dicionario
	current_save.collected_muiraquitas[id] = true
	
	# TODO: adicionar som de encontrar muiraquita
	
	# Emitir sinal para mostrar UI
	GlobalSignals.muiraquita_updated.emit(id)
