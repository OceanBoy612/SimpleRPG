tool
extends Node

func _ready():
	update_configuration_warning() # handle configuration errors

func _get_configuration_warning():
	if not get_parent() is Camera2D:
		return "This node requires a camera as a parent to work"
#	if bind_x_axis and x_axis_bounds.x > x_axis_bounds.y:
#		return "x bounds low is greater than high. May have unexpected behavior"
#	if bind_y_axis and y_axis_bounds.x > y_axis_bounds.y:
#		return "Y bounds low is greater than high. May have unexpected behavior"
	return ""


#### Camera Methods ####


export (NodePath) var target  # Assign the node this camera will follow.

# To limit the motion use the Limit variables in the camera itself
#export(bool) var bind_x_axis = false
#export(Vector2) var x_axis_bounds = Vector2(0, 0)
#export(bool) var bind_y_axis = false
#export(Vector2) var y_axis_bounds = Vector2(0, 0)


onready var cam : Camera2D = get_parent()


func _process(_delta):
	if Engine.editor_hint: # don't run in the editor
		return
	
#	if not cam:
	if not is_instance_valid(cam):
		return
	
	if not target:
		return
	
	var trgt = get_node_or_null(target)
	if not is_instance_valid(trgt):
		return
	
	cam.global_position = get_node(target).global_position
	
#	if bind_x_axis:
#		cam.global_position.x = \
#				clamp(cam.global_position.x, x_axis_bounds.x, x_axis_bounds.y)
#	if bind_y_axis:
#		cam.global_position.y = \
#				clamp(cam.global_position.y, y_axis_bounds.x, y_axis_bounds.y)
