extends Node2D

# Lever
@onready var lever := $lever

# Nife
@onready var nife := $nife

# Scientists
@onready var scientist_a := $scientist_a
@onready var scientist_b := $scientist_b

# Backgrounds
@onready var background_nife_1 := $backgrounds/bg_nife_1
@onready var background_nife_2 := $backgrounds/bg_nife_2
@onready var bg_scientists := $backgrounds/bg_scientists
@onready var bg_lever := $backgrounds/bg_lever

# ColorRect
@onready var colorino := $ColorRect

# Clipboard
@onready var clipboard := $clipboard
@onready var dyn_clip_spr := $clipboard/clipboard_spr
@onready var clipboard_anim := $clipboard/clipboard_anim

# Individual animation nodes
@onready var nife_anim := $nife/nife_anim
@onready var pivot_anim := $lever/lever_pivot/pivot_anim
@onready var scientist_a_anim := $scientist_a/scientist_a_anim
@onready var scientist_b_anim := $scientist_b/scientist_b_anim
# I TRIED to use a regular clip_children for this, but it was so jank I just gave up and did
# this simple workaround instead.
@onready var stupid_clip_workaround := $backgrounds/bg_nife_2_low_half

# Preload difficulty and language sprites
var clp_n := preload("res://Sprites/anim_cutscene/clipboard_eng.png")
var clp_h := preload("res://Sprites/anim_cutscene/clipboard_h_en.png")

var anim_depth := 0

# Why is this done like this? Because it's fun! And besides, it's not like the end-user will care.

func _ready() -> void:
	var current_difficulty = GlobalBus.difficulty
	match current_difficulty:
		"normal":
			dyn_clip_spr.texture = clp_n
		"hard":
			dyn_clip_spr.texture = clp_h
		"null":
			printerr("No difficulty?")
	SfxHandler.play_song("cutscene.ogg", 0.8)

func _on_fade_anim_animation_finished(anim_name: StringName) -> void:
	if anim_depth > 3:
		if GlobalBus.begin_up_timer != true:
			GlobalBus.begin_up_timer = true
		match GlobalBus.difficulty:
			"normal":
				SfxHandler.play_song("song_1.ogg", 1.0)
				get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
			"hard":
				SfxHandler.play_song("song_1.ogg", 1.0)
				get_tree().change_scene_to_file("res://Scenes/Levels/level_h1.tscn")
			"null":
				printerr("No difficulty?")
				SfxHandler.play_song("song_1.ogg", 1.0)
				get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
		return
	scientist_a_anim.play("eye_move")
	scientist_b_anim.play("eye_move_1")
	anim_depth += 1

func _on_scientist_a_anim_animation_finished(anim_name: StringName) -> void:
	background_nife_1.visible = true
	bg_scientists.visible = false
	scientist_a.visible = false
	scientist_b.visible = false
	nife.visible = true
	clipboard.visible = true
	await get_tree().create_timer(0.5).timeout
	clipboard_anim.play("move_down")
	anim_depth += 1

func _on_clipboard_anim_animation_finished(anim_name: StringName) -> void:
	await get_tree().create_timer(0.5).timeout
	nife_anim.play("happy")
	anim_depth += 1

func _on_nife_anim_animation_finished(anim_name: StringName) -> void:
	if anim_depth < 5:
		nife.visible = false
		var eye_right = scientist_a.get_child(3)
		var eye_confused = scientist_a.get_child(4)
		eye_right.visible = false
		eye_confused.visible = true
		scientist_a.visible = true
		scientist_b.visible = true
		bg_scientists.visible = true
		background_nife_1.visible = false
		clipboard.visible = false
		scientist_b_anim.play("eye_move_2")
		anim_depth += 1
	else:
		var temp := colorino.get_child(0)
		temp.play_backwards("fade")


func _on_scientist_b_anim_animation_finished(anim_name: StringName) -> void:
	if anim_depth < 3:
		return
	
	scientist_a.visible = false
	scientist_b.visible = false
	bg_scientists.visible = false
	bg_lever.visible = true
	lever.visible = true
	pivot_anim.play("grab & spin")
	anim_depth += 1


func _on_pivot_anim_animation_finished(anim_name: StringName) -> void:
	bg_lever.visible = false
	lever.visible = false
	nife.visible = true
	background_nife_1.visible = true
	nife_anim.play("fallen_down")
	anim_depth += 1
