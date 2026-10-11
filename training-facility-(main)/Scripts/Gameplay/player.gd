extends CharacterBody2D

var force_movement: int = 0
const SPEED: float = 200.0
var JUMP_VELOCITY: float = -450.0
const LOW_FRICTION: int = 100
var GRAVITY = Vector2(0, 980)
var MAX_SPEED: int = 1200
@onready var maplayer_fulltile: TileMapLayer = $"../Full_Tile" # This throws an error on the debugger but works anyways so who cares
@onready var animation_ballingo = $AnimatedSprite2D
@onready var collision_shapey = $CollisionShape2D
@onready var timerino = $Timer
@onready var gray_scale = $CanvasLayer/ColorRect
var new_speed = SPEED
var can_move: bool = true
var we_dead: bool
var instant_spawn: bool = false
var play_once_done: bool = false

func _ready() -> void:
	GlobalBus.connect("player_killed", player_killed)
	match GlobalBus.respawn_speed:
		0:
			timerino.wait_time = 2.0
		1:
			timerino.wait_time = 0.5
		2:
			instant_spawn = true

func _physics_process(delta: float) -> void:
	if force_movement != 0:
		velocity.x = SPEED * force_movement
		move_and_slide()
		return
	var previous_velocity = velocity
	# Add the gravity.
	if not is_on_floor():
		velocity += GRAVITY * delta
		new_speed = SPEED # Restore speed to default when airborne.
	
	# Handle jump.
	if Input.is_action_pressed("move_jump") and is_on_floor() and can_move == true:
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction and can_move == true:
		if direction > 0: # Check direction, then change animation frame.
			animation_ballingo.frame = 1
		elif direction < 0:
			animation_ballingo.frame = 2
		velocity.x = direction * SPEED
	elif can_move == true:
		velocity.x = move_toward(velocity.x, 0, new_speed)
		animation_ballingo.frame = 0 # Restore original idle animation frame
	
	# Thing below was commented out. Function "check_trampoline_collision" didn't quite work out :/
	#check_trampoline_collision(delta, previous_velocity_y)
	if velocity.y > MAX_SPEED:
		velocity.y = MAX_SPEED
	var pre_move_velocity = velocity
	
	move_and_slide()
	
	tile_map_collision(previous_velocity, pre_move_velocity)

func tile_map_collision(starting_velocity, pre_move_velocity):
	# DOMAIN EXPANSION: TURBO-SH*T CODE!
	# Loop through all collisions that happened in this frame
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Check if we hit a TileMapLayer
		if collider is TileMapLayer:
			var tilemap_layer: TileMapLayer = collider
			
			# Get the exact tile coordinates from the collision position
			# Slightly nudge the collision position inward using the normal to avoid rounding errors
			var collision_position = collision.get_position() - collision.get_normal()
			var tile_coords = tilemap_layer.local_to_map(tilemap_layer.to_local(collision_position))
			
			# Retrieve the TileData for that specific cell
			var tile_data: TileData = tilemap_layer.get_cell_tile_data(tile_coords)
			
			if tile_data:
				# Check which physics layer the collision belongs to
				var physics_layers_count = tilemap_layer.tile_set.get_physics_layers_count()
				
				for layer_index in range(physics_layers_count):
					# Check if this specific tile has a collision polygon on this physics layer
					if tile_data.get_collision_polygons_count(layer_index) > 0:
						match layer_index: # Match logic to collision index
							0: 
								new_speed = SPEED # Normal block, restore speed to normal
							1: 
								new_speed = 5 # Make it slippery
							2:
								# If statement was commented out to accomodate the gravity orb. HOPEFULLY it doesn't break anything.
								#if collision.get_normal().y < 0: 
								# Perfectly bounce the velocity using the collision normal.
								# We use starting_velocity to completely discard the extra gravity added this frame.
								var bounced_velocity = starting_velocity.bounce(collision.get_normal())
								
								# Apply the clean inverted Y velocity
								velocity.y = bounced_velocity.y
								
								#print("Clean Impact Speed: ", starting_velocity.y)
								#print("Clean Inverted Speed: ", velocity.y)
								return

func check_trampoline_collision(delta: float, incoming_velocity_y):
	var test_collision = move_and_collide(velocity * delta, true)
	if test_collision:
		var collider = test_collision.get_collider()
		if collider is TileMapLayer:
			var tilemap_layer: TileMapLayer = collider
			var collision_position = test_collision.get_position() - test_collision.get_normal()
			var tile_coords = tilemap_layer.local_to_map(tilemap_layer.to_local(collision_position))
			var tile_data: TileData = tilemap_layer.get_cell_tile_data(tile_coords)
			
			if tile_data.get_collision_polygons_count(2) > 0:
				velocity.y *= -1
				print("New vertical speed: " + str(velocity.y))

func player_killed():
	var materialize = gray_scale.material
	gray_it()
	if GRAVITY.y < 0:
		velocity.y = 450
	else:
		velocity.y = -450
	velocity.x = 0
	can_move = false
	animation_ballingo.frame = 3
	collision_shapey.set_deferred("disabled", true)
	self.z_index = 100
	GlobalBus.total_deaths += 1
	GlobalBus.post_reset_deaths += 1
	if instant_spawn != true:
		if GlobalBus.silly_mode == true and play_once_done != true:
			SfxHandler.play_sfx("cat_laugh.mp3")
			play_once_done = true
		elif play_once_done != true:
			SfxHandler.play_sfx("falling.mp3")
			play_once_done = true
		timerino.start()
		await timerino.timeout
	GlobalBus.player_reset.emit()
	if we_dead != true: # rubberband fix to prevent the below code being called twice, causing a null tree.
		materialize.set_shader_parameter("saturation", 1.0)
		get_tree().reload_current_scene()
		we_dead = true

func gray_it():
	var materialize = gray_scale.material
	var cool_val = 1.0
	while we_dead != true and materialize.get_shader_parameter("saturation") != 0.0:
		if (cool_val - 0.02) < 0.0:
			pass
		else:
			cool_val -= 0.02
		materialize.set_shader_parameter("saturation", cool_val)
		await get_tree().process_frame
