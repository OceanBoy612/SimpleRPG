extends RayCast2D

"""
A raycast that points in the direction that the KB is facing. 

Requires kb to have rotation

rotation is a normalized Vector2 pointing in the direction of movement
"""

onready var kb = get_parent() as KinematicBody2D
var talkin = false

func _ready():
	enabled = true
	collide_with_areas = true
	collide_with_bodies = false # ????


func _process(delta):
	if not kb:
		print("Facing requires a KinematicBody2D as a parent")
		return
	
	if kb.has_meta("rotation"):
		rotation = kb.get_meta("rotation")
	
	if is_colliding():
		var col = get_collider() as Interactable
		kb.set_meta("interactable", col)
#		if not talkin:
#			col.start_interaction()
#			talkin = true
#		if col:
#			print(col.name)
