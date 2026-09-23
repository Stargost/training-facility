extends Area2D

var can_teleport: bool = true
var sister_portal: NodePath
var sister: Area2D
var we_teleported: bool = false
@onready var machinima: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprity: Sprite2D = $Sprite2D
var sprite_open = preload("res://Sprites/portalb.png")
var sprite_closed = preload("res://Sprites/portalb_closed.png")

func get_sis():
	sister = get_node(sister_portal)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_teleport == true and we_teleported == false:
		var target_pos: Vector2 = sister.global_position
		body.global_position = target_pos
		sister.sprity.texture = sister.sprite_closed
		sister.we_teleported = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprity.texture = sprite_open
		we_teleported = false
