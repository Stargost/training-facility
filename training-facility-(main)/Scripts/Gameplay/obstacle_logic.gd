extends Area2D

## Makes the orb follow the player.
@export var make_more_evil: bool = false
## How fast it will move if Make More Evil is set to TRUE
@export var evil_speed: float = 10.0
## Ceiling used to calculate distance_factor. The lower it is, the less far away the player needs to be for distance_factor to ramp up.
@export var distance_maximum: float = 200
## floor on how far away the player must be for the calculations to do anything
@export var distance_minimum: float = 50
## Ceiling on how much it can accelerate depending on how far away the player is. Leave it at 0.0 for no acceleration.
@export var speed_factor: float = 0

@export var target: Node2D

var we_moded
var prev_speed

func _ready() -> void:
	if not target and make_more_evil:
		printerr("You forgot to give the evil orb a target, dumbass!")
		make_more_evil = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GlobalBus.player_killed.emit()
		make_more_evil = false

func _physics_process(delta: float) -> void:
	if make_more_evil:
		if not we_moded:
			prev_speed = evil_speed
		if speed_factor > 0.0:
			we_moded = true
			# Get distance and limit it to a number between 0 and 1
			var distance_factor := position.distance_to(target.position)
			# Use remap to account for minimum and maximum distances
			distance_factor = remap(distance_factor, distance_minimum, distance_maximum, 0.0, 1.0)
			# Clamp by hand because for some reason the clampf() function doesn't work.
			if distance_factor > 1.0:
				distance_factor = 1.0
			elif distance_factor < 0.0:
				distance_factor = 0
			#print(distance_factor)
			var target_speed : float = speed_factor * distance_factor
			evil_speed += target_speed
		#print(evil_speed)
		position += position.direction_to(target.global_position).normalized() * evil_speed * delta
		evil_speed = prev_speed # Reset speed
		#print(evil_speed)
