extends Node


export var speed = 400


onready var kb = get_parent() as KinematicBody2D


func _physics_process(delta):
	if not kb:
		print("Character controller requires a KinematicBody2D as a parent")
		return
	
	var axis: Vector2 = _get_input_axis()
	
	if axis != Vector2.ZERO:
		kb.set_meta("rotation", axis.angle())
	
	kb.set_meta("direction", speed * axis)
	kb.move_and_slide(speed * axis)



func _get_input_axis() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
