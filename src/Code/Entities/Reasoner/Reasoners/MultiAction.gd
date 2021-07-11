extends Reasoner
class_name MultiAction, "res://Code/Entities/Reasoner/Reasoners/multi_action.png"


"""
Plays child actions all together.
Completes when all children have been played
"""


func _on_ready_child(c):
	connect("enabled", c, "enable", [], CONNECT_DEFERRED) # enable children when self enables


func _on_child_action_disabled(c):
	if active_actions.size() == 0:
		emit_signal("completed", OK)
