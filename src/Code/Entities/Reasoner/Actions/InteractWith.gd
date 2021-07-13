extends EntityAction
#class_name InteractWith


"""
Causes an interaction to occur in the target node
"""

export var target_node: NodePath
export var bypass_disable: bool = true
#export var with_children: bool = false


func _on_enable():
	._on_enable()
#	if with_children:
#		var node = get_node(target_node)
#		if node:
#			for c in node.get_children():
#				c = c as InteractableEntity
#				if c == null: continue
#				do_the_thing(c)
#	else:
#		var node: InteractableEntity = get_node(target_node)
#		if node:
#			do_the_thing(node)
	
	var node = get_node(target_node)
	if node is InteractableEntity:
		do_the_thing(node)
	else:
		for c in node.get_children():
			if c is InteractableEntity:
				do_the_thing(c)
	emit_signal("completed", OK)
	

func do_the_thing(node: InteractableEntity):
	if bypass_disable:
		node.emit_signal("interacted_with", entity)
	else:
		node.start_interaction(entity)
