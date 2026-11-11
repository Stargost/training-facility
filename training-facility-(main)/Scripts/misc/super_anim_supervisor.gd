extends Node2D

@onready var timer_1 := $Timer
@onready var anim_player := $panel_animation
@onready var text_anim := $text_animation

var inception_rate: int = 0

func _on_timer_timeout() -> void:
	if inception_rate >= 1:
		text_anim.play("fade")
	else:
		anim_player.play("section 1")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if "fade" not in anim_name:
		timer_1.wait_time = 1.5
		timer_1.start()
		inception_rate += 1
	else:
		match anim_name: # Play animation after the fade animation finished
			"fade 1":
				anim_player.play("section 2")
			"fade 2":
				anim_player.play("section 3")
			"fade 3":
				anim_player.play("section 4")
			"fade 4":
				anim_player.play("section 5")
			"fade 5":
				anim_player.play("section 6")
			"fade 6":
				anim_player.play("section 7")
			"fade 7":
				anim_player.play("section 8")
			"fade 8":
				anim_player.play("section 9")
			"fade 9":
				anim_player.play("section 10")
			"fade 10":
				if GlobalBus.difficulty == "normal":
					get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
				else:
					get_tree().change_scene_to_file("res://Scenes/Levels/level_h1.tscn")

func _input(event: InputEvent) -> void:
	var allow_skip: bool = true
	if Input.is_action_just_pressed("move_jump"): # Check correct key
		if anim_player.is_playing() == true: # Check if we are playing a regular animation
			if allow_skip == true:
				anim_player.advance(7.0)
				return
		# If we are not playing a regulaar animation, go to the next one.
		match inception_rate:
			1:
				anim_player.play("fade 1")
			2:
				anim_player.play("fade 2")
			3:
				anim_player.play("fade 3")
			4:
				anim_player.play("fade 4")
			5:
				anim_player.play("fade 5")
			6:
				anim_player.play("fade 6")
			7:
				anim_player.play("fade 7")
			8:
				anim_player.play("fade 8")
			9: 
				anim_player.play("fade 9")
			10:
				anim_player.play("fade 10")
		# Stop the player from being able to skip while the fade animation is playing
		text_anim.play_backwards("fade")
		allow_skip = false
		await anim_player.animation_finished
		allow_skip = true
