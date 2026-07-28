extends State

var attack_timer: Timer


func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.one_shot = true
	attack_timer.autostart = false
	attack_timer.set_wait_time(2)
	add_child(attack_timer)
	
	

func _process(_delta: float) -> void:
	pass

func _enter() -> void:
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_timer.start()
	
func _physics_process(_delta: float) -> void:
	pass

func _exit() -> void:
	attack_timer.timeout.disconnect(_on_attack_timer_timeout)

func _on_attack_timer_timeout():
	transition_to("Aim")
