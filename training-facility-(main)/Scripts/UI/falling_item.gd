extends Sprite2D

var fall_speed: float = 300.0 # Pixels per second
var spin_speed: float = 3.0  # Radians per second
var screen_height: float = 800.0 # Adjust to your project settings

func _ready() -> void:
	# Randomize spin direction and slight speed variance
	spin_speed *= randf_range(-1.2, 1.2)
	# Randomize fall speed slightly so they don't look uniform
	fall_speed *= randf_range(0.8, 1.2)

func _process(delta: float) -> void:
	# Move downward at a constant speed
	position.y += fall_speed * delta
	
	# Spin continuously
	rotation += spin_speed * delta
	
	# Free memory once it's safely off-screen
	if position.y > screen_height + 100:
		queue_free()
