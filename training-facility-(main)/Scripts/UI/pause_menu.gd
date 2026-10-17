extends Control

var parent

func _ready() -> void:
	parent = get_parent()

func _on_unpause_pressed() -> void:
	parent.kill_pause_menu()

func _on_quit_to_title_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
