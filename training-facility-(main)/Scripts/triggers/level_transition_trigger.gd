extends Area2D

## Level name must be string. Can be a number, a name, or both. "4", "especial", "construct_12", etc.
@export var level_name: String
var level_list

func _ready() -> void:
	if GlobalBus.level_list.is_empty():
		GlobalBus.scan_levels()
	level_list = GlobalBus.level_list

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if level_name not in level_list:
			printerr("Attempted to load a level that doesn't exist. Defaulting...")
			get_tree().change_scene_to_file(level_list["1"])
			return
		var pointer = level_list[level_name]
		SfxHandler.stop_sfx(true)
		get_tree().change_scene_to_file(pointer)
