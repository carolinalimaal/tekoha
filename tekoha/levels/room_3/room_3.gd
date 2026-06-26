extends Level

@export var bg_music: AudioStream
@onready var state_machine: StateMachine = $StateMachine

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
		_:
			# Para os estados que não tem eventos importantes aqui
			state_machine.change_state("3_Generic")
