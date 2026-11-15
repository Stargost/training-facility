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
	
	# We use "[color=#ffffff00]_[/color]" in between the double line breaks because Godot doesn't like double line breaks for some reason.
	# PRD: Deaths Overall. - TD: Deaths on this run. 
	var text_prd_n: String = ""
	var text_td: String = tr("CONGRATS_TD_TXT")
	var text_prd: String = ""
	var tttext: String = tr("CONGRATS_TT_TXT")
	var texto_diff: String
	var text_td_n: String = str(GlobalBus.post_reset_deaths)
	
	if GlobalBus.difficulty == "normal":
		texto_diff = tr("CONGRATS_DIFF_NORMAL_TXT")
		GlobalBus.game_won = true
	elif GlobalBus.difficulty == "hard":
		GlobalBus.game_won = true
		GlobalBus.game_won_on_hard = true
		texto_diff = tr("CONGRATS_DIFF_HARD_TXT")
	var texto_1: String = tr("CONGRATS_ONE_TXT")
	var texto_2: String = tr("CONGRATS_TWO_TXT")
	if GlobalBus.enable_prd_text == true:
		text_prd_n = str(GlobalBus.total_deaths)
	# Test code, comment out on release builds.
	#text_prd_n = str(GlobalBus.total_deaths) 
	#text_prd = "[br]" + tr("CONGRATS_PRD_TXT")
	
	final_text.text = texto_diff + "[br][color=#ffffff00]_[/color][br]" + texto_1 + "[br][color=#ffffff00]_[/color][br]" + tttext + final_time + "[br]" + text_td + text_td_n + text_prd + text_prd_n + "[br][color=#ffffff00]_[/color][br]" + texto_2
	nine_slice_resize()
	GlobalBus.save_savefile()

func nine_slice_resize():
	await get_tree().process_frame
	# Stupid workaround to weird bug.
	# For some reason, Godot interprets the size of the margin container as:
	# x: ((normal)), y: 4000-ish.
	# Waiting for 1 frame fixes this.
	nine_patchy.size = margin_cont.size
