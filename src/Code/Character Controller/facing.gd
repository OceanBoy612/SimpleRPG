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
	
	look_at(get_global_mouse_position())
	
#	if kb.has_meta("rotation"):
#		rotation = kb.get_meta("rotation")
	
	if is_colliding():
		var col = get_collider() as Interactable
		col.focused()
		kb.set_meta("interactable", col)
	elif kb.has_meta("interactable"):
		kb.get_meta("interactable").unfocused()
		kb.set_meta("interactable", null)
		
#		if not talkin:
#			col.start_interaction()
#			talkin = true
#		if col:
#			print(col.name)
