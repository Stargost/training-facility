extends Control

@onready var volume_slider := $MarginContainer/VBoxContainer/Volume
@onready var brightness_slider := $MarginContainer/VBoxContainer/HSlider
@onready var silly_button := $MarginContainer/VBoxContainer/Silly_Mode
@onready var cutscene_toggle := $MarginContainer/VBoxContainer/Cutscene_Toggle
@onready var respawn_options := $MarginContainer/VBoxContainer/Respawn_Time
@onready var trans_options := $MarginContainer/VBoxContainer/Translation
@onready var enable_prd := $MarginContainer/VBoxContainer/Enable_PRD # Post Reset Deaths
@onready var old_cutscene_toggle := $MarginContainer/VBoxContainer/Old_Cutscene_Toggle

var shaderino := preload("res://misc/shader_hologram_preset_b.tres")

func _ready() -> void:
	volume_slider.set_value_no_signal(GlobalBus.volume_level)
	brightness_slider.set_value_no_signal(GlobalBus.brightness - 20)
	silly_button.button_pressed = GlobalBus.silly_mode
	cutscene_toggle.button_pressed = !GlobalBus.enable_start_cutscene
	respawn_options.selected = GlobalBus.respawn_speed
	if GlobalBus.language_selected == "en":
		trans_options.selected = 0
	elif GlobalBus.language_selected == "es":
		trans_options.selected = 1
	
	# Do some bullshit to apply shaders correctly.
	var popup_a: PopupMenu = respawn_options.get_popup()
	popup_a.about_to_popup.connect(boutta_pop_a)
	var popup_b: PopupMenu = trans_options.get_popup()
	popup_b.about_to_popup.connect(boutta_pop_b)

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	GlobalBus.volume_level = value
	SfxHandler.update_song_volume()

func _on_silly_mode_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalBus.silly_mode = true
	else:
		GlobalBus.silly_mode = false

func _on_h_slider_value_changed(value: float) -> void:
	if value < 5.0:
		value = 5.0
	GlobalBus.brightness = value + 20.0
	GlobalBus.check_brightness.emit()

func _on_respawn_time_item_selected(index: int) -> void:
	GlobalBus.respawn_speed = index

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			TranslationServer.set_locale("en")
			GlobalBus.language_selected = "en"
		1:
			TranslationServer.set_locale("es")
			GlobalBus.language_selected = "es"

func boutta_pop_a():
	var popup: PopupMenu = respawn_options.get_popup()
	
	for child in popup.get_children(true):
		#print(child)
		if child is PanelContainer:
			for grandchildren in child.find_children("*", "", true, false):
				if "PopupMenuItems" in grandchildren.name:
					grandchildren.material = shaderino
			
			child.material = shaderino

func boutta_pop_b():
	var popup: PopupMenu = trans_options.get_popup()
	
	for child in popup.get_children(true):
		#print(child)
		if child is PanelContainer:
			for grandchildren in child.find_children("*", "", true, false):
				if "PopupMenuItems" in grandchildren.name:
					grandchildren.material = shaderino
			
			child.material = shaderino

func _on_cutscene_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalBus.enable_start_cutscene = false
	else:
		GlobalBus.enable_start_cutscene = true

func _on_enable_prd_toggled(toggled_on: bool) -> void:
	GlobalBus.enable_prd_text = toggled_on

func _on_old_cutscene_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalBus.enable_old_cutscene = true
	else:
		GlobalBus.enable_old_cutscene = false
