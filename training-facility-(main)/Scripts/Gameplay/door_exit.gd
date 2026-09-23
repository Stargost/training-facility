extends AnimatableBody2D

## Determines the amount of coins left required for the door to open.
@export var coins_needed: int = 0
var total_coins: int
var must_move: bool = false
@onready var machinima = $AnimationPlayer
@onready var collisionator = $CollisionShape2D

func _ready() -> void:
	GlobalBus.card_picked.connect(move_shit)
	total_coins = get_tree().get_nodes_in_group("card_pickup").size()

func move_shit():
	total_coins -= 1
	if total_coins <= coins_needed:
		machinima.play("door_open")
		collisionator.set_deferred("disabled", true)
		SfxHandler.play_sfx("door_a.mp3", 0.6, 2)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
