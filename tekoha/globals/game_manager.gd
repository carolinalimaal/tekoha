extends Node

enum GameState {
	NEW_GAME,
	BEFORE_FISHING,
	FIRST_MEETING_IARA,
	TRAINING_COMPLETE,
	FIRST_MEETING_CECILIA,
	AFTER_FIRST_ENEMY,
	SECOND_MEETING_CECILIA,
	IN_KITCHEN,
	AFTER_CECILIA_GIFT,
	IN_ROOM_8,
	AFTER_PUZZLE_1,
	AFTER_PUZZLE_2,
	ROOM_14_UNLOCKED,
	TOOLS_COLLECTED,
	AFTER_PUZZLE_3,
	PRE_BOSSFIGHT,
	BOSSFIGHT,
	POS_BOSSFIGHT,
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

	# Emitir sinal para mostrar UI
	GlobalSignals.wallet_updated.emit(current_save.wallet)

func _remove_coin(value: int) -> void:
	if current_save.wallet >= value:
		current_save.wallet -= value
		GlobalSignals.wallet_updated.emit(current_save.wallet)

func _register_muiraquita(id: int) -> void:
	# Registrar no dicionario
	current_save.collected_muiraquitas[id] = true
	
	if !current_save.known_items.has("muiraquita"):
		current_save.known_items["muiraquita"] = true
		GlobalRefs.new_item_found_panel.show_panel(GlobalRefs.ItemType.MUIRAQUITA, null)

	# Emitir sinal para mostrar UI
	GlobalSignals.muiraquita_updated.emit(id)

func set_game_state(new_state: GameState) -> void:
	if new_state and new_state != current_save.game_state:
		current_save.game_state = new_state
		GlobalSignals.game_state_changed.emit(new_state)
