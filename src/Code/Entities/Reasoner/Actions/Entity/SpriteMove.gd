extends EntityAction
class_name SpriteMove

"""
This causes the entity's sprite to move along two curves
"""

export(Curve) var x_curve : Curve
export(Curve) var y_curve : Curve
export(Curve) var x_scale : Curve
export(Curve) var y_scale : Curve
export(Curve) var rot_curve : Curve

export(float) var duration = 1.0
var reset_on_end = true # This has to be true because this class is currently not safe for interrupts
#export(bool) var reset_on_end = true


var current_time = 0
var start_pos : Vector2
var start_rot : float
var start_scale : Vector2


func _on_enable():
	._on_enable()
	current_time = 0
	start_pos = entity.sprite.position
	start_rot = entity.sprite.rotation_degrees
	start_scale = entity.sprite.scale


func _process(delta):
	current_time += delta
	if current_time > duration:
		emit_signal("completed", OK)
		return 
	move_sprite(current_time / duration)


func _on_disable():
	if reset_on_end and entity:
		entity.sprite.position = start_pos
		entity.sprite.rotation_degrees = start_rot
		entity.sprite.scale = start_scale
	._on_disable()

func move_sprite(weight):
	var new_pos = Vector2(
		x_curve.interpolate(weight) if x_curve else start_pos.x,
		-y_curve.interpolate(weight) if y_curve else start_pos.y
	)
	var new_scale = Vector2(
		x_scale.interpolate(weight) if x_scale else start_scale.x,
		y_scale.interpolate(weight) if y_scale else start_scale.y
	)
	var new_rot = rot_curve.interpolate(weight) if rot_curve else start_rot
	entity.sprite.position = new_pos
	entity.sprite.scale = new_scale
	entity.sprite.rotation_degrees = new_rot
