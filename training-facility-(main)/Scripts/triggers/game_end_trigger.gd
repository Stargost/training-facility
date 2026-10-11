extends Area2D

@onready var color_fade_out := $ColorRect
var player
var frame_wait := 2
var alpha_Q := 0.05

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player.force_movement = 1
		fade_work()

func fade_work():
	var curent_frame := 0
	while color_fade_out.color[3] + alpha_Q < 1.00001: # Rubberband to prevent it fading out at 1.0 - Alpha_Q
		if curent_frame == 0:
			color_fade_out.color += Color(0, 0, 0, alpha_Q)
			#print(color_fade_out.color)
			curent_frame = frame_wait
			await get_tree().process_frame
		else:
			curent_frame -= 1
			await  get_tree().process_frame
	GlobalBus.last_level = "null"
	GlobalBus.save_savefile()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
