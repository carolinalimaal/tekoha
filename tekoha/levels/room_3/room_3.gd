extends Level

const TRANSITION_FADE_DURATION := 0.5

@export var bg_music: MusicTrack
@onready var state_machine: StateMachine = $StateMachine

var _transition_overlay: CanvasLayer = null

func _ready() -> void:
	AudioManager.play_background_sound(bg_music)
	state_machine.init(self)
	change_room_state()

func _process(_delta: float) -> void:
	pass

func change_room_state() -> void:
	var current_game_state = GameManager.current_save.game_state
	var current_room_state = state_machine.current_state

	match current_game_state:
		GameManager.GameState.BEFORE_FISHING:
			current_room_state.transition_to("3_1")
		GameManager.GameState.FIRST_MEETING_IARA:
			current_room_state.transition_to("3_2")
		GameManager.GameState.FIRST_MEETING_CECILIA:
			current_room_state.transition_to("3_3")
		GameManager.GameState.PRE_BOSSFIGHT:
			current_room_state.transition_to("3_4")
		_:
			# Para os estados que não tem eventos importantes aqui
			state_machine.change_state("3_Generic")

func show_transition_overlay() -> void:
	if GlobalRefs.hud:
		GlobalRefs.hud.hide()

	if _transition_overlay:
		return

	_transition_overlay = CanvasLayer.new()
	_transition_overlay.layer = 0
	var overlay := ColorRect.new()
	overlay.color = Color.BLACK
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_transition_overlay.add_child(overlay)
	add_child(_transition_overlay)

func hide_transition_overlay() -> void:
	if GlobalRefs.hud:
		GlobalRefs.hud.show()

	if !_transition_overlay:
		return

	var canvas := _transition_overlay
	var overlay: ColorRect = canvas.get_child(0)
	_transition_overlay = null

	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 0.0, TRANSITION_FADE_DURATION)
	tween.tween_callback(canvas.queue_free)
