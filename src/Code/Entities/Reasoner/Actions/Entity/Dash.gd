extends EntityAction
class_name Dash

"""
Makes the entity dash in the direction that it is looking at
"""

export(Curve) var speed_curve : Curve
export(float) var duration = 1.0
export(bool) var relative_to_target = false
export(float) var max_distance = 100 # this is only for relative-to-target


var current_time = 0
var mult = 1.0


func _on_enable():
	._on_enable()
	entity.move_dir = entity.look_dir
	current_time = 0
	mult = 1.0
	if relative_to_target:
		# if speed curve is 1. then we will get to the target.
		var dir = (entity.target.global_position - entity.global_position)
		var dash_speed = min(dir.length(), max_distance) / duration
		mult = dash_speed / entity.speed


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
	var curve_output = speed_curve.interpolate(time) if speed_curve else 1.0
	
	entity.speed_multiplier = curve_output * mult
	

#	kb.speed_multiplier = dash_speed / kb.speed
