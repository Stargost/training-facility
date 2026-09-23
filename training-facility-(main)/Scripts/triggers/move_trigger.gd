extends Area2D

## The target object. It will break if you point it at anything that isn't a
## Node2D or similar.
@export var target_obj: Node2D
## Decides whether this can be used multiple times or just once
@export var is_single_use: bool
## The amount to be moved, remember that moving up in the Y coordinates needs
## a negative value.
@export var move_amount: Vector2
## The time it takes to move, in seconds.
@export var time_for_move: float
## When this option is set to TRUE, the target object will be deleted once the
## tween is finished. The trigger cannot be reused after this, essentially
## acting as if "is_single_use" were also set to TRUE
@export var delete_on_finish: bool
var just_moved: bool = false
var single_move_done: bool = false


func move_object():
	var target_pos = target_obj.position + move_amount
	
	if single_move_done == false:
		var tweene = create_tween()
		tweene.tween_property(target_obj, "position", target_pos, time_for_move)
		await tweene.finished
		just_moved = false
		if delete_on_finish == true:
			target_obj.queue_free()
			single_move_done = true
		if is_single_use == true:
			single_move_done = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and just_moved == false:
		just_moved = true
		move_object()
