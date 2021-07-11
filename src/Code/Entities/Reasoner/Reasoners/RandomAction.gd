extends Reasoner
class_name RandomAction, "res://Code/Entities/Reasoner/Reasoners/random_action.png"

"""
Plays a random child action.
Completes when any of its children are done
"""


func _on_ready():
	randomize()
	._on_ready()


func _on_enable():
	._on_enable()
	var ind = randi() % get_child_count()
	get_child(ind).enable()


func _on_child_action_completed(c):
	emit_signal("completed", OK)

