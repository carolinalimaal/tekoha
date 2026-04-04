class_name LoadingScreen extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	GlobalSignals.door_entered.connect(on_door_entered)
	GlobalSignals.level_loading_finished.connect(on_level_loading_finished)

func on_door_entered() -> void:
	animation_player.play("fade_out")

func report_midpoint() -> void:
	GlobalSignals.emit_signal("animation_midpoint_reached")

func on_level_loading_finished() -> void:
	animation_player.play("fade_in")
	
func start_process() -> void:
	get_tree().paused = false
