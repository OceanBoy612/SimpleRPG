extends Reasoner
class_name MultiAction, "res://Code/Entities/Reasoner/Reasoners/multi_action.png"


"""
Plays child actions all together.
Completes when all children have been played
"""


func _on_ready_child(c):
	connect("enabled", c, "enable") # enable children when self enables





func _on_child_action_disabled(c):
	# if all children are disabled - emit completed
	for c in get_children():
		c = c as ActionBase
		if not c: continue
		if c.is_processing(): # one of the children is still running
			return
	
	emit_signal("completed")
	pass
