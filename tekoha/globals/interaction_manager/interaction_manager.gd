extends CanvasLayer

@onready var container: MarginContainer = $MarginContainer
@onready var rich_label: RichTextLabel = $MarginContainer/RichTextLabel

var active_areas: Array = []
var current_interactable
var current_marker: Marker2D

func _ready() -> void:
	container.hide()
	rich_label.bbcode_enabled = true
	InputManager.input_source_changed.connect(_on_input_source_changed)

# Atualiza a posição da UI para seguir o Marker2D no mundo
func _process(_delta: float) -> void:
	if current_interactable != null and current_marker != null and container.visible:
		# Converte a posição do Marker no mundo (2D) para a posição na tela (Canvas)
		var screen_position = current_marker.get_global_transform_with_canvas().origin
		container.position = screen_position - (container.size / 2)

func _unhandled_input(_event: InputEvent) -> void:
	if UIManager.is_interact_ui_open:
		return
	if InputManager.get_action_pressed("interact") and current_interactable != null:
		if !get_tree().paused:
			# Se o input for consumido aqui, nao propaga para o resto dos _unhandled_input do jogo
			get_viewport().set_input_as_handled()
			if current_interactable.has_method("interact"):
				current_interactable.interact()
				container.hide()

func register_interactable(interactable: Node, text: String, marker: Marker2D) -> void:
	var exists = false
	for area in active_areas:
		if area.node == interactable:
			exists = true
			break
			
	if !exists:
		active_areas.append({"node": interactable, "text": text, "marker": marker})
		_update_prompt()

func unregister_interactable(interactable: Node) -> void:
	for i in range(active_areas.size() - 1, -1, -1):
		if active_areas[i].node == interactable:
			active_areas.remove_at(i)
	_update_prompt()

func _update_prompt() -> void:
	if active_areas.is_empty():
		container.hide()
		current_interactable = null
		current_marker = null
	else:
		var active = active_areas.back()
		current_interactable = active.node
		current_marker = active.marker
		rich_label.text = InputManager.icon_mapper.parse_input_text(active.text)
		container.show()

func _on_input_source_changed(_source: InputManager.InputSource) -> void:
	if current_interactable:
		_update_prompt()
