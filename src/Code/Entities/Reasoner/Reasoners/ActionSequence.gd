extends Reasoner
class_name ActionSequence, "res://Code/Entities/Reasoner/Reasoners/action_sequence.png"

"""
Plays child actions in sequence.
Completes when all children have been played
"""


var ind = 0


func _on_enable():
	._on_enable()
	ind = -1
	goto_next_action()


func _on_child_action_completed(c):
	if not goto_next_action():
		emit_signal("completed", OK)


func goto_next_action() -> bool:
	ind += 1
	if ind >= get_child_count():
		return false
	
	var action: ActionBase = get_child(ind)
	
	if action: action.enable()
	else:      return goto_next_action()
	
	return true


