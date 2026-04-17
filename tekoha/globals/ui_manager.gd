extends Node

# Dicionário para guardar as referências de todos os menus
var menus: Dictionary = {}
# Pilha de menus abertos
var menu_stack: Array[Control] = []

var is_interact_ui_open: bool = false

# Função que os menus vão chamar no _ready() deles para se registrar
func register_menu(menu_name: String, menu_node: Control) -> void:
	menus[menu_name] = menu_node
	menu_node.hide()

# Abre um menu e coloca ele no topo da pilha
func open_menu(menu_name: String) -> void:
	if not menus.has(menu_name):
		push_warning("UIManager: Menu não registrado - ", menu_name)
		return
	
	var menu = menus[menu_name]
	
	# Evita abrir o mesmo menu se ele já estiver na pilha
	if menu in menu_stack:
		return
		
	# Se a pilha estava vazia, significa que é o primeiro menu e pausa o jogo
	if menu_stack.is_empty():
		get_tree().paused = true
		
	menu.show()
	menu_stack.push_back(menu)
	
	# Se o menu tiver uma função chamada grab_initial_focus, o Maestro a executa
	if menu.has_method("grab_initial_focus"):
		menu.grab_initial_focus()

# Fecha o menu que estiver no topo da pilha
func close_top_menu() -> void:
	if menu_stack.is_empty():
		return
		
	var top_menu = menu_stack.pop_back()
	if top_menu.has_method("close_ui"):
		top_menu.close_ui()
	else:
		top_menu.hide()
	
	# Se fechar o último menu e a pilha ficou vazia, despausa o jogo
	if menu_stack.is_empty():
		get_tree().paused = false
	else:
		# Se ainda tem menus na pilha, devolve o foco para o menu que ficou no topo
		var previous_menu = menu_stack.back()
		if previous_menu.has_method("grab_initial_focus"):
			previous_menu.grab_initial_focus()

# Função utilitária para limpar tudo de uma vez
func close_all_menus() -> void:
	for menu in menu_stack:
		if menu.has_method("close_ui"):
			menu.close_ui()
		else:
			menu.hide()
	menu_stack.clear()
	get_tree().paused = false
