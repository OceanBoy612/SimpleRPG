extends CombatEntityAction
class_name ManualTargetSelect

"""
Manually sets the target to the nodepath
"""

export(NodePath) var path
export(bool) var oneshot = true


#func _on_enable():
#	._on_enable()
#	entity.target = get_node(path)
#	emit_signal("completed", OK)

func _process(delta):
	entity.target = get_node(path)
	if oneshot:
		emit_signal("completed", OK)
