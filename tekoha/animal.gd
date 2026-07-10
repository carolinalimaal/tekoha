extends AnimatedSprite2D

@export var animated_frames: SpriteFrames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_frames = animated_frames


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
