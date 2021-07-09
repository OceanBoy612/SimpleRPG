extends ActionBase
class_name FollowMouse


func _process(delta):
	get_base().global_position = get_global_mouse_position()
