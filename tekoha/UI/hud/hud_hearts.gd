extends PanelContainer

const HEART_SIZE: int = 4

@export var heart_icon: PackedScene

@onready var heart_container: HBoxContainer = $HeartContainer

func _ready() -> void:
	GlobalRefs.player.health_changed.connect(_on_health_changed)
	
	call_deferred("_on_health_changed")

func _on_health_changed():
	var hp = GlobalRefs.player.get_node("HealthComponent").current_health
	var max_hp = GlobalRefs.player.get_node("HealthComponent").max_health
	heart_container.update_hearts(hp, max_hp)
