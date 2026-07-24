extends AnimatedSprite2D

@export var animated_frames: SpriteFrames
@export var flyer: bool = false
@export var flipped: bool = false

var speed: int
var direction: int

var room_limit_left: int
var room_limit_right: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if flipped:
		flip_h = true
	sprite_frames = animated_frames
	if flyer:
		speed = 300


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flyer:
		global_position.x += direction * speed * delta
		
		if flipped and global_position.x < room_limit_left:
			queue_free()
			
		elif !flipped and global_position.x > room_limit_right:
			queue_free()
