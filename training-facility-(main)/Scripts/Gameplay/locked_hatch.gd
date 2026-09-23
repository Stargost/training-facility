extends StaticBody2D

## Determine if the hatch should start in its open state.
@export var start_open: bool = false

@onready var sprity = $AnimatedSprite2D
@onready var collisionator = $CollisionShape2D
var sound_played: bool = false

func _ready() -> void:
	if start_open == true:
		sprity.frame = 7
		collisionator.set_deferred("disabled", true)

func _on_animated_sprite_2d_frame_changed() -> void:
	if sprity.frame > 0 and start_open != true:
		collisionator.set_deferred("disabled", true)
	else:
		collisionator.set_deferred("disabled", false)
	if sound_played != true:
		if start_open != true and sprity.frame != 7:
			SfxHandler.play_sfx("door_b.mp3", 0.8)
			sound_played = true
		elif sprity.frame != 7:
			SfxHandler.play_sfx("door_b.mp3", 0.8)
			sound_played = true

func _on_animated_sprite_2d_animation_finished() -> void:
	sound_played = false
