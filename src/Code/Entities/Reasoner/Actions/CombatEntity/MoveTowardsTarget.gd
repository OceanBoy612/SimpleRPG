extends CombatEntityAction
#class_name MoveTowardsTarget

"""
Requires a CombatEntity parent

Steers the entity towards its target 
"""

export(float, 0, 1) var max_turn_radius = 1


func _physics_process(delta):
	entity.move_dir = entity.move_dir.linear_interpolate(
			entity._vec_to_target().normalized(), max_turn_radius)
#	entity.move_dir = entity._vec_to_target().normalized()

