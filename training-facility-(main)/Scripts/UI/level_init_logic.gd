extends Node2D

var res: Vector2
@onready var camera = $Camera2D
@export var target_res := Vector2(544, 416)

func _ready() -> void:
	res = get_viewport().get_visible_rect().size
	var temporay_current_scene = get_tree().current_scene.scene_file_path
	GlobalBus.last_level = temporay_current_scene
	if GlobalBus.was_game_saved == false:
		GlobalBus.was_game_saved = true
	zoom_to_res()
	settinger()
	GlobalBus.save_savefile()

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
