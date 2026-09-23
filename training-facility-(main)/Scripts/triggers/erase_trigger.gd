extends Area2D

@export var target_obj: NodePath
@export var target_obj_2: NodePath
var node_object
var node_object_2

func _ready() -> void:
	node_object = get_node(target_obj)
	node_object_2 = get_node(target_obj_2)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if node_object != null:
			node_object.queue_free()
			node_object = null
		if node_object_2 != null:
			node_object_2.queue_free()
			node_object_2 = null
