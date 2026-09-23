extends Area2D

var player
var can_jump: bool = false
var coyote_time: float = 0.3
var jump_buffer: bool = true
var jump_done: bool = false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")

func _process(delta: float) -> void:
	if can_jump == true:
		if Input.is_action_pressed("move_jump") and jump_buffer == true and can_jump == true and jump_done == false:
			if player[0].up_direction == Vector2(0, -1):
				player[0].velocity.y = -450
			elif player[0].up_direction == Vector2(0, 1):
				player[0].velocity.y = 450
			jump_buffer = false
			jump_done = true
		elif Input.is_action_just_pressed("move_jump") and can_jump == true and jump_done == false:
			if player[0].up_direction == Vector2(0, -1):
				player[0].velocity.y = -450
			elif player[0].up_direction == Vector2(0, 1):
				player[0].velocity.y = 450
			jump_done = true
	if Input.is_action_just_released("move_jump"):
		jump_done = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_jump = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(coyote_time)
		can_jump = false
		jump_buffer = true
