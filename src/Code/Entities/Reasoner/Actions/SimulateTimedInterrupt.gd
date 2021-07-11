extends ActionBase
class_name SimulateTimedInterrupt


export(NodePath) var path
export(float) var time = 1


func _on_enable():
	._on_enable()
	yield(get_tree().create_timer(time), "timeout")
	var node = get_node(path)
	emit_signal("completed", OK)
	if node:
		# in order to avoid disabling self if we are interrupting the parent
		# we first ccomplete, then try to interrupt the node in a deferred way. 
		node.call_deferred("emit_signal", "completed", name)
#		node.emit_signal("completed", name)
