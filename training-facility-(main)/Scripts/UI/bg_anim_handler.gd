extends Node2D

var item_scene: PackedScene = preload("res://Scenes/falling_item.tscn")

var item_collection = preload("res://Sprites/bg_anim_text.tres")

@onready var timerino: Timer = Timer.new()

var screen_width: float = 800.0

func _ready() -> void:
	add_child(timerino)
	timerino.wait_time = 0.5
	timerino.timeout.connect(_on_timerino_timeout)
	timerino.start()


func _on_timerino_timeout():
	var new_item = item_scene.instantiate() as Sprite2D
	
	var total_frames = item_collection.get_frame_count("default")
	var random_frame = randi() % total_frames
	
	var texture = item_collection.get_frame_texture("default", random_frame)
	
	new_item.texture = texture
	
	var random_x = randf_range(0, screen_width)
	new_item.position = Vector2(random_x, -100)
	add_child(new_item)
