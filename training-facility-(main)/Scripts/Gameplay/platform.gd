extends AnimatableBody2D

var is_active: bool = true
var machinima_node
var associated_trigger

func _ready() -> void:
	for child in get_children():
		if child is AnimationPlayer:
			machinima_node = child
	if associated_trigger:
		var trigerino = get_node(associated_trigger)
		if trigerino:
			trigerino.connect("check_actuation", checkers)
			trigerino.connect("activate", activate)
			trigerino.connect("deactivate", deactivate)
			trigerino.connect("invert_actuation", invert_actuation)

func checkers():
	if machinima_node:
		if is_active == true:
			machinima_node.play()
		elif is_active == false:
			machinima_node.pause()
	else:
		printerr("Object has no AnimationPlayer child!")

func activate():
	machinima_node.play()

func deactivate():
	machinima_node.pause()

func invert_actuation():
	if machinima_node.is_playing() == true:
		machinima_node.pause()
	else:
		machinima_node.play()
