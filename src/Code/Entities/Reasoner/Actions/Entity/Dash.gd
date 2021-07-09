extends EntityAction
class_name Dash

"""
Makes the entity dash in the direction that it is looking at
"""

export(Curve) var speed_curve : Curve
export(float) var duration = 1.0


var current_time = 0


func _on_enable():
	._on_enable()
	entity.move_dir = entity.look_dir
	current_time = 0
	assert(speed_curve)


func _process(delta):
	current_time += delta
	if current_time > duration:
		emit_signal("completed")
		return 
	
	entity.speed_multiplier = speed_curve.interpolate(current_time / duration)
