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


func _on_disable():
	._on_disable()
	if entity:
		seek(1)


func _process(delta):
	current_time += delta
	if current_time > duration:
		emit_signal("completed", OK)
		return 
	
	seek(current_time / duration)

func seek(time):
	entity.speed_multiplier = speed_curve.interpolate(time)
	
