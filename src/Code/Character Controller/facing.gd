extends RayCast2D

"""
A raycast that points in the direction that the KB is facing. 

Requires kb to have rotation

rotation is a normalized Vector2 pointing in the direction of movement
"""

onready var kb = get_parent() as KinematicBody2D
onready var weapon = $Weapon
onready var path = $Weapon/Path2D/PathFollow2D
var talkin = false

func _ready():
	enabled = true
	collide_with_areas = true
	collide_with_bodies = false # ????


func _process(_delta):
	if not kb:
		print("Facing requires a KinematicBody2D as a parent")
		return
	
	look_at(get_global_mouse_position())
	
	var lookDirection = Vector2(cos(self.rotation), sin(self.rotation)).normalized()
	if lookDirection.x < 0 and weapon.scale.y == 1:
		weapon.reset_sword()
		weapon.scale.y = -1
	elif lookDirection.x >= 0 and weapon.scale.y == -1:
		weapon.reset_sword()
		weapon.scale.y = 1
	
#	if kb.has_meta("rotation"):
#		rotation = kb.get_meta("rotation")
	
	if is_colliding():
#		var col = get_collider() as Interactable
		var col = get_collider()
		if is_instance_valid(col) and col.has_method("focused"):
			col.focused()
			kb.set_meta("interactable", col)
	elif kb.has_meta("interactable"):
		if is_instance_valid(kb.get_meta("interactable")): # need a better sol...
			kb.get_meta("interactable").unfocused()
			kb.set_meta("interactable", null)
		
#		if not talkin:
#			col.start_interaction()
#			talkin = true
#		if col:
#			print(col.name)
