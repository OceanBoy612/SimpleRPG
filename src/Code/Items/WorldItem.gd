extends Entity
class_name WorldItem


func on_physics_process(delta):
	# decay speed
	if speed > 1:
		speed *= 0.9
	else:
		speed = 0
