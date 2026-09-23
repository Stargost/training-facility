extends Area2D

## The object to be targeted.
@export var target_obj: NodePath
## How many degrees it should be rotated, in degrees.
@export var rotation_amount: int
## Determine if the object should rotate forever. If set to TRUE, the rotation amount will determine
## rotation direction (positive = clockwise; negative = counter-clockwise)
@export var is_infinite: bool
## How fast it should speed, in degrees.
@export var rotation_speed: float
## Determine if the trigger stops taking player signals after the first use.
@export var is_single_use: bool

var new_target_obj
var radiano

func _ready() -> void:
	new_target_obj = get_node(target_obj)

func _physics_process(delta: float) -> void:
	new_target_obj.rotate(deg_to_rad(rotation_speed))
