extends PanelContainer

const HEART_SIZE: int = 4

@export var heart_icon: PackedScene

@onready var player: Player = GlobalRefs.player
@onready var health_component: HealthComponent = player.get_node("HealthComponent")

@onready var hb_hearts: HBoxContainer = $HBHearts

func _ready() -> void:
	player.health_changed.connect(on_player_damaged)
	
	var total_hearts = ceil(health_component.max_health / float(HEART_SIZE))
	
	for i in range(total_hearts):
		var heart_instance = heart_icon.instantiate()
		hb_hearts.add_child(heart_instance)
		
	call_deferred("update_heart_sprite")
	
func update_heart_sprite():
	var health_remaining = health_component.current_health
	var hearts = hb_hearts.get_children()
	
	for heart: Heart in hearts:
		var value_to_display = clampi(health_remaining, 0, 4)
		heart.update_sprite(value_to_display)
		health_remaining -= 4
	
func on_player_damaged():
	update_heart_sprite()
