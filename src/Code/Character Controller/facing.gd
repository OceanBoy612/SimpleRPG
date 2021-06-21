extends RayCast2D

"""
A raycast that points in the direction that the KB is facing. 

Requires kb to have rotation

rotation is a normalized Vector2 pointing in the direction of movement
"""

onready var kb = get_parent() as KinematicBody2D

func _process(delta):
	if not kb:
		print("Facing requires a kinematic body 2D as a parent")
		return
	
	if kb.has_meta("rotation"):
		rotation = kb.get_meta("rotation")
