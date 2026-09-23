extends Area2D

@onready var sprity = $AnimatedSprite2D
@export var is_permanent: bool
@export var timeout_time: float
@onready var timerino = $Timer
var unavailable: bool = false
signal button_timed_out

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprity.frame = 1
		if is_permanent == false:
			timerino.wait_time = timeout_time
		if unavailable == true:
			SfxHandler.play_sfx("button_deny.mp3")
		else:
			SfxHandler.play_sfx("button_ok.mp3")
			unavailable = true

func _on_timer_timeout() -> void:
	sprity.frame = 0
	button_timed_out.emit()
	unavailable = false
