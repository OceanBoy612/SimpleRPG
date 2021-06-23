extends State

"""
This state chooses the closest target.
walks up to it
attacks once
ends
"""

#func on_enable():
#	target_nearest_enemy()
#
#	if not kb.target: # no target found
#		print("Couldn't find a target for Attack")
#		emit_signal("completed")


func _physics_process(delta):
	print("hi")
	if Engine.editor_hint:
		set_physics_process(false)
		return
	
	(kb as CombatEntity).last_attack_time = 0
	(kb as CombatEntity).target = null
	print("completed")
	emit_signal("completed")
#
#	# walk towards the target
#	var to_target = kb.target.global_position-global_position
#	kb.move_dir = to_target
#
#	# when within range attack
#	if to_target.length() < kb.attack_range:
#		kb.target = null
#		kb.move_dir = Vector2()
#		emit_signal("completed")
#
#	update()


### Helpers ###



### Helpers ###


### DEBUG ###

func _draw():
	if not DEBUG:
		return
	
	# TODO: This should move to the CombatEntity debug class
	draw_arc(Vector2(), kb.attack_range, 0, 2*PI, 32, Color("#ff1111"))


