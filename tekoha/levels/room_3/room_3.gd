extends Level

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	state_machine.init(self)
