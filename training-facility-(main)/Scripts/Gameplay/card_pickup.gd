extends Area2D


func _on_body_entered(body: Node2D) -> void:
	GlobalBus.card_picked.emit()
	SfxHandler.play_sfx("coin_jingle.mp3")
	queue_free()
