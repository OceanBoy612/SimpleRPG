extends EntityAction
#class_name LookAtMouse

"""
Makes the entity look at the mouse
"""


func _physics_process(delta):
	entity.look_dir = entity.global_position.direction_to(get_global_mouse_position())
	
