extends Control

@onready var nine_patchy := $NinePatchRect
@onready var margin_cont := $MarginContainer
@onready var final_text := $MarginContainer/RichTextLabel

var margin_size := Vector2(10, 5)

var play_time: float
var playthrough_deaths: int
var global_deaths: int
var final_time: String

func _ready() -> void:
	playthrough_deaths = GlobalBus.post_reset_deaths
	global_deaths = GlobalBus.total_deaths
	GlobalBus.begin_up_timer = false
	
	# Convert the time from float into human-readable format (MM:SS:MS)
	play_time = GlobalBus.total_time
	var minutes = int(play_time/60)
	var seconds = int(play_time) % 60
	var milliseconds = int((play_time - int(play_time)) * 10000)
	# Use placeholder string thingies to display the timer.
	final_time = "%02d:%02d:%04d" % [minutes, seconds, milliseconds]
	
	var patch_size: Vector2 = nine_patchy.size
	margin_cont.position += margin_size
	margin_cont.size = Vector2(patch_size - margin_size)
