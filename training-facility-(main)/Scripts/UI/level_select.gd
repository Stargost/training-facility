extends Control

@onready var nine_slicy = $NinePatchRect
@onready var button_new_game = $HBoxContainer/new_game
@onready var button_load_game = $HBoxContainer/load_game
@onready var button_difficulty_select = $OptionButton

var shaderino = preload("res://misc/shader_hologram_preset_c.tres")
var difficulty_selected: int
var level_list: Dictionary
var is_saved_level: bool

func _ready() -> void:
	var popup: PopupMenu = button_difficulty_select.get_popup()
	popup.about_to_popup.connect(boutta_pop)

func _on_visibility_changed() -> void:
	var temp = GlobalBus.was_game_saved
	
	if GlobalBus.level_list.is_empty():
		GlobalBus.scan_levels()
	level_list = GlobalBus.level_list
	
	if str(temp) == "false" or GlobalBus.last_level == "null":
		button_load_game.disabled = true

func _on_new_game_pressed() -> void:
	if GlobalBus.enable_start_cutscene == true:
		SfxHandler.play_song("song_1.ogg", 0.0)
		get_tree().change_scene_to_file("res://Scenes/misc/start_cutscene.tscn")
	else:
		SfxHandler.play_song("song_1.ogg")
		GlobalBus.begin_up_timer = true
		match GlobalBus.difficulty:
			"normal":
				get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
			"hard":
				get_tree().change_scene_to_file("res://Scenes/Levels/level_h1.tscn")
			"null":
				printerr("No difficulty?")
				get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")

func _on_option_button_item_selected(index: int) -> void:
	difficulty_selected = index
	match index:
		null:
			printerr("No difficulty?")
		0:
			GlobalBus.difficulty = "normal"
		1:
			GlobalBus.difficulty = "hard"

func _on_load_game_pressed() -> void:
	SfxHandler.play_song("song_1.ogg")
	GlobalBus.begin_up_timer = true
	get_tree().change_scene_to_file(GlobalBus.last_level)

func boutta_pop():
	var popup: PopupMenu = button_difficulty_select.get_popup()
	
	for child in popup.get_children(true):
		#print(child)
		if child is PanelContainer:
			for grandchildren in child.find_children("*", "", true, false):
				if "PopupMenuItems" in grandchildren.name:
					grandchildren.material = shaderino
			
			child.material = shaderino
