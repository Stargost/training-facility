extends Area2D

## Targeted object.
@export var target_obj: NodePath
## Determine if the trigger should become inactive after 1 use.
@export var is_single_use: bool
## Determines the actuation mode. 0 = only activates. 1 = only deactivates.
## 2 = both in sequence (activation first). 3 = both in sequence (deactivation first)
## 4 = inverts activation.
@export var actuation_mode: int
## If set to TRUE, sends out a signal instead of a simple property change, making Target Obj useless.
@export var make_global: bool
var new_target_obj
var is_object_valid: bool = true
var single_use_done = false
var sequence_segment: int = 0
signal activate
signal deactivate
signal invert_actuation
signal check_actuation

func _ready() -> void:
	new_target_obj = get_node(target_obj)
	if "associated_trigger" not in new_target_obj:
		# Value "associated_trigger" should be a blank var with that exact name
		printerr("Object isn't set up properly. Lacks 'associated_trigger' value in script.")
	else:
		new_target_obj.associated_trigger = get_path()
		#print(get_path())
	
	if "is_active" not in new_target_obj:
		# Value "is_active" should be a blank var of that exact name defined as a boolean
		printerr("Object doesnt have the 'is_active' variable within it.")
		is_object_valid = false

func _on_body_entered(body: Node2D) -> void:
	if is_object_valid == true and single_use_done == false and body.is_in_group("player"):
		match actuation_mode: # match to current actuation mode setting alongside checking make_global
			# If the object DOESN'T support global actuation, then just set the checker function.
			0:
				if make_global == true:
					activate.emit()
				else:
					new_target_obj.is_active = true
			1:
				if make_global == true:
					deactivate.emit()
				else:
					new_target_obj.is_active = false
			2:
				if make_global == true:
					if sequence_segment == 0:
						activate.emit()
						sequence_segment = 1
					elif sequence_segment == 1:
						deactivate.emit()
						sequence_segment = 0
				else:
					if sequence_segment == 0:
						new_target_obj.is_active = true
						sequence_segment = 1
					elif sequence_segment == 1:
						new_target_obj.is_active = false
						sequence_segment = 0
			3:
				if make_global == true:
					if sequence_segment == 0:
						deactivate.emit()
						sequence_segment = 1
					elif sequence_segment == 1:
						activate.emit()
						sequence_segment = 0
				else:
					if sequence_segment == 0:
						new_target_obj.is_active = false
						sequence_segment = 1
					elif sequence_segment == 1:
						new_target_obj.is_active = true
						sequence_segment = 0
			4:
				if make_global == true:
					invert_actuation.emit()
				else:
					if new_target_obj.is_active == false:
						new_target_obj.is_active = true
					else:
						new_target_obj.is_active = false
		check_actuation.emit()
		#print("test")
	if is_single_use == true and body.is_in_group("player"):
		single_use_done = true
