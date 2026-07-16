extends AnimatedSprite2D

@export var animated_frames: SpriteFrames
@export var flyer: bool = false
@export var flipped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if flipped:
		flip_h = true
	sprite_frames = animated_frames


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
