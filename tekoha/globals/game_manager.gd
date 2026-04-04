extends Node

enum GameState {
	NEW_GAME,
	TALKED_TO_IARA
}

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
	
	if !current_save.known_items.has("coin"):
		current_save.known_items["coin"] = true
		GlobalRefs.new_item_found_panel.show_panel(GlobalRefs.ItemType.COIN, null)
	
	# TODO: adicionar som de coletar moeda
	# Emitir sinal para mostrar UI
	GlobalSignals.wallet_updated.emit(current_save.wallet)

func _register_muiraquita(id: int) -> void:
	# Registrar no dicionario
	current_save.collected_muiraquitas[id] = true
	
	if !current_save.known_items.has("muiraquita"):
		current_save.known_items["muiraquita"] = true
		GlobalRefs.new_item_found_panel.show_panel(GlobalRefs.ItemType.MUIRAQUITA, null)
	
	# TODO: adicionar som de encontrar muiraquita
	# Emitir sinal para mostrar UI
	GlobalSignals.muiraquita_updated.emit(id)
