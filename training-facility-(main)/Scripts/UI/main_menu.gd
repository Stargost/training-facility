extends Node2D

var settings = preload("res://Scenes/settings.tscn")
var ui_settings
var ui_credits: bool = false
var ui_level_submenu: bool = false
@onready var return_button = $return_button
@onready var bg = $NinePatchRect
@onready var credits = $RichTextLabel
@onready var settings_button = $settings_button
@onready var play_button = $play_button
@onready var credits_button = $credits_button
@onready var game_version = $version_text
@onready var level_submenu = $level_select
@onready var logo = $logo
var buttons: Array



func _ready() -> void:
	game_version.text = ProjectSettings.get_setting("application/config/version")
	var worlder = WorldEnvironment.new()
	worlder.environment = Environment.new()
	worlder.environment.background_mode = Environment.BG_CANVAS
	worlder.environment.adjustment_enabled = true
	worlder.environment.adjustment_brightness = (GlobalBus.brightness / 100)
	add_child(worlder)
	buttons = [credits_button, settings_button, play_button]
	GlobalBus.connect("check_brightness", checking_shut_up)
	GlobalBus.load_configfile()
	GlobalBus.load_savefile()
	SfxHandler.play_song("menu.ogg")

func _on_play_button_pressed() -> void:
	level_submenu.visible = true
	for i in buttons:
		i.disabled = true
		i.visible = false
	return_button.disabled = false
	return_button.visible = true
	ui_level_submenu = true
	logo.visible = false

func _on_settings_button_pressed() -> void:
	# Visibility and disabling stuff
	for i in buttons:
		i.disabled = true
		i.visible = false
	logo.visible = false
	ui_settings = settings.instantiate()
	ui_settings.global_position = Vector2(200, 100)
	add_child(ui_settings)
	return_button.disabled = false
	return_button.visible = true
	bg.global_position = Vector2(ui_settings.global_position.x - 50, ui_settings.global_position.y - 10)
	bg.size = Vector2(484, 376)
	bg.visible = true
	SfxHandler.play_sfx("misc_menu.wav")

func _on_return_button_pressed() -> void:
	logo.visible = true
	if ui_settings != null:
		ui_settings.queue_free()
		for i in buttons:
			i.disabled = false
			i.visible = true
		return_button.disabled = true
		return_button.visible = false
		bg.visible = false
		GlobalBus.save_configfile()
	elif ui_credits:
		for i in buttons:
			i.disabled = false
			i.visible = true
		credits.visible = false
		return_button.disabled = true
		return_button.visible = false
		bg.visible = false
		ui_credits = false
	elif ui_level_submenu == true:
		for i in buttons:
			i.disabled = false
			i.visible = true
		level_submenu.visible = false
		return_button.disabled = true
		return_button.visible = false
	SfxHandler.play_sfx("misc_menu.wav")

func _on_credits_button_pressed() -> void:
	ui_credits = true
	# Disable visibility and usability.
	for i in buttons:
		i.disabled = true
		i.visible = false
	logo.visible = false
	bg.visible = true
	return_button.visible = true
	return_button.disabled = false
	credits.visible = true
	bg.global_position = credits.global_position
	bg.global_position.y = credits.global_position.y - 10
	bg.size = credits.size
	SfxHandler.play_sfx("misc_menu.wav")

func checking_shut_up():
	var worlder
	for child in get_children():
		if is_instance_of(child, WorldEnvironment):
			worlder = child
	worlder.environment.adjustment_brightness = (GlobalBus.brightness / 100)
