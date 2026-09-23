extends Area2D

## The target object. Must be a NodePath. This will break if you parse it anything that isn't an
## AnimationPlayer node.
@export var target_obj: AnimationPlayer
## In case the target object isn't an AnimationPlayer node, use this. Will break if the target object
## isn't set up properly.
@export var secondary_target_obj: NodePath
## The animation to be targeted. It is a case-sensitive string.
@export var obj_1_animation: String
## The secondary animation. It is a case-sensitive string.
@export var secondary_obj_animation: String
## Determine wether the animation should loop or not.
## 0: No looping.
## 1: Loop linearly.
## 2: Loop ping-pong.
@export var select_loop_mode: int
## Tells the trigger to pause the animation instead of playing another one.
@export var pause_animation: bool
## Tells the trigger to stop the animation instead of playing another one.
@export var stop_animation: bool
## Allows the animation to be queued until the current one is finished. Does not work for anything
## other than an AnimationPlayer node.
@export var queue_animation: bool
## Determine wether the trigger can be activated multiple times.
## Touching a trigger multiple times will NOT make the animation reset or
## queue if "queue_animation" and "stop_animation" are set to FALSE.
@export var is_single_use: bool
## If it is ON, the animation will play in reverse.
@export var play_reversed: bool

var animation_to_play
var disable_animation_play: bool = false
var new_secondary_target
var animated_sprite: AnimatedSprite2D = null

func _ready() -> void:
	if secondary_target_obj:
		# Get the variable as a node and assign it to new_secondary_target
		new_secondary_target = get_node_or_null(secondary_target_obj)
		if new_secondary_target is AnimatedSprite2D:
			animated_sprite = new_secondary_target
		else: # Go over every children to see if there is a valid node type.
			for child in new_secondary_target.get_children():
				if child is AnimatedSprite2D:
					animated_sprite = child
					break
		if not animated_sprite:
			printerr("Object does not have a valid target or target children.")
		elif animated_sprite.sprite_frames.has_animation(secondary_obj_animation) != true:
			printerr("Parsed animation does not exist.")
		else:
			animated_sprite.sprite_frames.set_animation_loop_mode(secondary_obj_animation, select_loop_mode)
	elif target_obj:
		animation_to_play = target_obj.get_animation(obj_1_animation)
		animation_to_play.loop_mode = select_loop_mode

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") && disable_animation_play == false:
		if animated_sprite and (pause_animation == false or stop_animation == false):
			if play_reversed == true:
				animated_sprite.play_backwards(secondary_obj_animation)
			else:
				animated_sprite.play(secondary_obj_animation)
		elif pause_animation == true:
			animated_sprite.pause()
		elif stop_animation == true:
			animated_sprite.stop()
		
		
		if target_obj != null && (pause_animation == false or stop_animation == false or queue_animation == false):
			if play_reversed == true:
				target_obj.play_backwards(obj_1_animation)
			else:
				target_obj.play(obj_1_animation)
		elif target_obj != null && pause_animation == true:
			target_obj.pause()
		elif target_obj != null && stop_animation == true:
			target_obj.stop()
		elif target_obj != null && queue_animation == true:
			target_obj.queue(obj_1_animation)
		
		if is_single_use:
			disable_animation_play = true
