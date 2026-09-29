extends Node2D

#Note to self: Never do something this complicated ever again.

@onready var raycast: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D
@onready var damage_area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

@export var max_length: float = 1000.0
@export var forward_direction: Vector2 = Vector2.UP 

# Animation Variables
@export var animation_fps: float = 12.0
var current_frame: int = 0
var animation_timer: float = 0.0
const TOTAL_FRAMES: int = 4

var is_active: bool = false

func _ready() -> void:
	# Correct direction fix
	raycast.target_position = forward_direction * max_length
	damage_area.body_entered.connect(_on_player_entered)
	set_active(is_active)

func _physics_process(delta: float) -> void:
	if not is_active:
		return
	
	# Handle Frame Animation via Shader parameter
	animation_timer += delta
	var time_per_frame = 1.0 / animation_fps
	if animation_timer >= time_per_frame:
		animation_timer = 0.0
		current_frame = (current_frame + 1) % TOTAL_FRAMES
		# Send the active frame index straight to the shader
		line_2d.material.set_shader_parameter("current_frame", current_frame)
	
	# Calculate Arc Length & Collisions
	raycast.force_raycast_update()
	
	var end_point: Vector2
	if raycast.is_colliding():
		end_point = line_2d.to_local(raycast.get_collision_point())
	else:
		end_point = forward_direction * max_length
	
	# Update the Line2D visual path
	line_2d.points = [Vector2.ZERO, end_point]
	
	# Update the SegmentShape2D collision line
	update_collision_shape(end_point)

func set_active(active: bool) -> void:
	is_active = active
	visible = active
	damage_area.set_deferred("monitoring", active)
	damage_area.set_deferred("monitorable", active)

func update_collision_shape(end_point: Vector2) -> void:
	var segment = collision_shape.shape as SegmentShape2D
	if segment:
		segment.b = end_point

func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		GlobalBus.player_killed.emit()
