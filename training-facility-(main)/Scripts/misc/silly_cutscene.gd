extends Node2D

## Determines how fast the cutscene is when skipping it. 1 is default, 2 is double, 3 is triple, and so on.
@export var baltimore_fast_speed: float = 20 

@onready var baltimore := $VideoStreamPlayer
@onready var time_it := $Timer
@onready var machinima := $Label/AnimationPlayer

var second_pass: bool = false

func _on_video_stream_player_finished() -> void:
	if GlobalBus.begin_up_timer != true:
		GlobalBus.begin_up_timer = true
	if GlobalBus.difficulty == "normal":
		SfxHandler.play_song("song_1.ogg")
		get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
	else:
		SfxHandler.play_song("song_1.ogg")
		get_tree().change_scene_to_file("res://Scenes/Levels/level_h1.tscn")

func _on_timer_timeout() -> void:
	if second_pass == false:
		time_it.wait_time = 15.0
		time_it.start()
		machinima.play("fade")
		second_pass = true
	else:
		machinima.play_backwards("fade")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip_cutscene"):
		# This is funnier but I'm leaving the original function call just in case.
		baltimore.speed_scale = baltimore_fast_speed
		
		#_on_video_stream_player_finished()
