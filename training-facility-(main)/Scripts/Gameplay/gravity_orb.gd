extends Area2D

var player
var can_jump: bool = false
var rotated: bool = false
var coyote_time: float = 0.3
var jump_buffer: bool = true
var jump_done: bool = false
@onready var sprity = $Sprite2D

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")
	GlobalBus.connect("flip_now", flip_yourself_now)

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_jump") and (jump_buffer and can_jump) == true and jump_done == false:
		player[0].GRAVITY.y *= -1
		player[0].up_direction.y *= -1
		player[0].JUMP_VELOCITY *= -1
		player[0].animation_ballingo.flip_v = !player[0].animation_ballingo.flip_v
		GlobalBus.flip_now.emit()
		jump_buffer = false
		jump_done = true
	elif Input.is_action_just_pressed("move_jump") and can_jump == true and jump_done == false:
		player[0].GRAVITY.y *= -1
		player[0].up_direction.y *= -1
		player[0].JUMP_VELOCITY *= -1
		player[0].animation_ballingo.flip_v = !player[0].animation_ballingo.flip_v
		GlobalBus.flip_now.emit()
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

func flip_yourself_now():
	sprity.flip_v = !sprity.flip_v
