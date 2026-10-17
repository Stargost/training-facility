extends Node2D

var res: Vector2
@onready var camera := $Camera2D
@export var target_res := Vector2(544, 416)
var is_paused: bool = false
var pause_menu_scene := preload("res://Scenes/pause_menu.tscn")
var pause_menu
var is_player_dead: bool = false

func _ready() -> void:
	res = get_viewport().get_visible_rect().size
	var temporay_current_scene = get_tree().current_scene.scene_file_path
	GlobalBus.last_level = temporay_current_scene
	if GlobalBus.was_game_saved == false:
		GlobalBus.was_game_saved = true
	zoom_to_res()
	settinger()
	GlobalBus.save_savefile()
	GlobalBus.connect("player_killed", player_killed)

func zoom_to_res():
	var zoom_x = res.x / target_res.x
	var zoom_y = res.y / target_res.y
	
	camera.zoom = Vector2(zoom_x, zoom_y)
	camera.position = target_res / 2

func settinger():
	var worlder = WorldEnvironment.new()
	worlder.environment = Environment.new()
	worlder.environment.background_mode = Environment.BG_CANVAS
	worlder.environment.adjustment_enabled = true
	worlder.environment.adjustment_brightness = (GlobalBus.brightness / 100)
	add_child(worlder)

func _input(event: InputEvent) -> void:
	if is_player_dead == true:
		return
	if event.is_action_pressed("pause"):
		if is_paused == false:
			is_paused = true
			for i in get_children():
				i.process_mode = Node.PROCESS_MODE_DISABLED # Functionally the same as pausing the scene
			pause_menu = pause_menu_scene.instantiate()
			pause_menu.position = target_res / 2
			add_child(pause_menu)
		else:
			is_paused = false
			for i in get_children():
				if i.name == "pause_menu": # Compare string to node name
					i.queue_free()
				i.process_mode = Node.PROCESS_MODE_INHERIT # Resume scene

## This assumes the pause menu exists and the game is paused.
func kill_pause_menu():
	if is_paused == false:
		printerr("ERROR: Game is not paused")
		return
	for i in get_children():
		if i.name == "pause_menu":
			i.queue_free()
		i.process_mode = Node.PROCESS_MODE_INHERIT
	is_paused = false

func player_killed():
	is_player_dead = true
