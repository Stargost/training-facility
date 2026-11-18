extends Node2D

@onready var machinima := $panel_animation
@onready var text_anim := $text_animation
@onready var image1 := $panels/End1
@onready var image2 := $panels/End2
@onready var image3 := $panels/ComicEndscreen
@onready var the_timer := $Timer

var image1_hard := preload("res://Sprites/anim_cutscene/new_anim_cutscene/end_1_hard.png")
var image2_hard := preload("res://Sprites/anim_cutscene/new_anim_cutscene/end_2_hard.png")
var image3_hard := preload("res://Sprites/anim_cutscene/new_anim_cutscene/comic_endscreen_hard.png")

var image_set: Array
var image_id: int = 0

var inception_rate: int = 0
var has_started: bool = false
var can_play_anim: bool = true

func _ready() -> void:
	image_set = [image1, image2, image3] # Declare here because of race condition. Damn racist Godot
	SfxHandler.stop_music()
	SfxHandler.play_song("cutscene.ogg")
	if GlobalBus.difficulty == "hard":
		for i in image_set:
			match image_id:
				0:
					image_id += 1
					i.texture = image1_hard
				1:
					image_id += 1
					i.texture = image2_hard
				2:
					i.texture = image3_hard

func _on_timer_timeout() -> void:
	if inception_rate >= 1 and can_play_anim == true: # Start the fade animation for the text
		can_play_anim = false
		text_anim.play("fade")
	elif inception_rate == 0:
		machinima.play("section 1")
		has_started = true

func _on_panel_animation_animation_finished(anim_name: StringName) -> void:
	if "fade" not in anim_name:
		# Reuses the timer node from a buffer before starting to a countdown for the text fade animation
		the_timer.wait_time = 1.5
		the_timer.start()
		inception_rate += 1
		can_play_anim = true
	else:
		can_play_anim = false
		match anim_name:
			"fade 1":
				machinima.play("section 2")
			"fade 2":
				machinima.play("section 3")
			"fade 3":
				machinima.play("section 4")
			"fade 4":
				GlobalBus.begin_up_timer = false
				GlobalBus.total_time = 0.0
				get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip_cutscene"):
		if machinima.is_playing() == true:
			machinima.advance(7.0)
			return
		match inception_rate:
			1:
				machinima.play("fade 1")
			2:
				machinima.play("fade 2")
			3:
				machinima.play("fade 3")
			4:
				machinima.play("fade 4")
		if has_started == true: # Prevent bug where the player can force the fade animation while nothing is playing
			text_anim.play_backwards("fade")
			can_play_anim = true
