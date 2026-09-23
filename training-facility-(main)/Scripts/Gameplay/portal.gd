extends Area2D

## Place the other portal here.
@export var sister_portal: NodePath
## If this is ON, the portal will work both ways.
@export var is_two_ways: bool = true
var sister: Area2D
var target_pos: Vector2
var we_on: bool = true
var we_teleported: bool = false
@onready var machinima: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprity: Sprite2D = $Sprite2D
var sprite_closed: Resource = preload("res://Sprites/portal_closed.png")
var sprite_open: Resource = preload("res://Sprites/portal.png")

func _ready() -> void:
	if sister_portal:
		sister = get_node(sister_portal)
		if not sister:
			printerr("Sister object not set up. Fix it you idiot!")
			return
		target_pos = sister.global_position
		sister.sister_portal = get_path()
		if is_two_ways == false:
			sister.can_teleport = false
		sister.get_sis()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and we_teleported == false:
		body.global_position = target_pos
		sister.we_teleported = true
		sister.sprity.texture = sister.sprite_closed

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprity.texture = sprite_open
		we_teleported = false
