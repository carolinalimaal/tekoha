extends Control

@export_range(1.0, 1000.0, 1.0) var credits_time: float = 50.0
@export var delay_before_start: float = 0.1

@export var bg_music: MusicTrack
@export var main_menu_scene: String = "res://UI/main_menu/main_menu.tscn"
@export var allow_skip: bool = false

@export var scroll_container: ScrollContainer
@export var content: VBoxContainer
@export var top_spacer: Control
@export var bottom_spacer: Control
@export var navigation_legend: NavigationLegend

var _finished: bool = false
var _tween: Tween

func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
	
	if GameManager.allow_skip_credits:
		allow_skip = GameManager.allow_skip_credits
		if allow_skip and navigation_legend:
			navigation_legend.visible = allow_skip

	if scroll_container:
		scroll_container.scroll_vertical = 0
		# Deixa transparente até o TopSpacer ter seu tamanho calculado, evitando
		# o flash do texto aparecendo no topo antes de ser empurrado pra baixo.
		# Usa modulate (não hide/visible) para não interferir no layout/scroll.
		scroll_container.modulate.a = 0.0

	# Aguarda um frame para garantir que a árvore e o viewport estejam prontos
	await get_tree().process_frame
	
	var window_height: float = get_viewport_rect().size.y
	
	# Configura o tamanho dos espaçadores com base na tela
	if top_spacer:
		top_spacer.custom_minimum_size.y = window_height
	if bottom_spacer:
		bottom_spacer.custom_minimum_size.y = window_height
	
	# Aguarda mais dois frames para o Godot recalcular a árvore de UI inteira com as novas alturas mínimas
	await get_tree().process_frame
	await get_tree().process_frame
	
	if delay_before_start > 0:
		await get_tree().create_timer(delay_before_start).timeout
	
	if _finished:
		return

	if scroll_container:
		scroll_container.modulate.a = 1.0

	var content_height: float = content.get_combined_minimum_size().y
	var max_scroll: float = max(0.0, content_height - window_height)
	
	if max_scroll > 0:
		_tween = create_tween()
		_tween.set_trans(Tween.TRANS_LINEAR)
		_tween.set_ease(Tween.EASE_IN_OUT)
		_tween.tween_property(scroll_container, "scroll_vertical", int(max_scroll), credits_time)
		_tween.finished.connect(finish)
	else:
		finish()

func _input(_event: InputEvent) -> void:
	if allow_skip and InputManager.get_action_pressed("ui_cancel"):
		finish()

func finish() -> void:
	if _finished:
		return
	_finished = true

	if _tween and _tween.is_valid():
		_tween.kill()

	if main_menu_scene != "" and ResourceLoader.exists(main_menu_scene):
		get_tree().change_scene_to_file(main_menu_scene)
	else:
		push_warning("Credits: defina 'main_menu_scene' com o caminho correto da sua cena de menu.")
