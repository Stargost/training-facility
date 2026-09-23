extends Node2D

## The object to be targeted by the trigger.
@export var target_obj: Node2D
## Determine if the trigger should begin acting from the start without player input.
@export var autostart := false
## Determine if the trigger will continue working indefinitely. Does not work if autostart == TRUE
@export var is_continuous := false
## How much it will move before stopping.
@export var total_angle_change := 0.0
## The center position for handling the rotation. So the point around which the object rotates.
@export var center_point := Vector2(0,0)
## The radius of the circle. Can be am oval too.
@export var radius := 100.0
## Velocity of movement in radians.
@export var speed := 1.0
## Initial offset from starting position, in degrees.
@export var offset_angle := 0.0

var current_angle := 0

func _physics_process(delta: float) -> void:
	pass
