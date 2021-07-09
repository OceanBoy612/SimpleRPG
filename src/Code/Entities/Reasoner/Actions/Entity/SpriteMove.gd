extends EntityAction
class_name SpriteMove

"""
This causes the entity's sprite to move along two curves
"""

export(Curve) var x_curve : Curve
export(Curve) var y_curve : Curve
export(float) var duration = 1.0


var current_time = 0


func _on_enable():
	._on_enable()
	current_time = 0
	assert(x_curve)
	assert(y_curve)


func _process(delta):
	current_time += delta
	if current_time > duration:
		emit_signal("completed")
		return 
	move_sprite(current_time / duration)


func move_sprite(weight):
	var new_pos = Vector2(
		x_curve.interpolate(weight),
		-y_curve.interpolate(weight)
	)
	entity.sprite.position = new_pos
