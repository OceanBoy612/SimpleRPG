extends ActionBase
#class_name InteractWith / EmitSignal (new name)


"""
Causes an interaction to occur in the target node
"""

export var signal_name: String = "interacted_with"
export var target_node: NodePath


func _on_enable():
	._on_enable()
	
	var node = get_node(target_node)
	if node.has_signal(signal_name):
		do_the_thing(node)
	else:
		for c in node.get_children():
			do_the_thing(c)
	emit_signal("completed", OK)
	

func do_the_thing(node):
	if node.has_signal(signal_name):
		node.emit_signal(signal_name, get_base())
	else:
		print("interactwith failed - %s - no interacted_with signal" % node.name)
#	else:
#		if node.has_method("start_interaction"):
#			node.start_interaction(get_base())
#		else:
#			print("interactwith failed - %s - no start interaction method" % node.name)
