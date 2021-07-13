extends CombatEntityAction
#class_name InterruptWhenCloseToTarget # when can attack this needs to change

#export(NodePath) var action_path
var action_path = ".." # always interrupt parent
export var dist_to_target = 50
export var cooldown = 1.0
var time_since_last_interrupt = 0


#func _on_enable():
#	._on_enable()
#	entity.connect("attacked", self, "entity_attacked")
#	time_since_last_interrupt = 0


#func entity_attacked():
#	set_physics_process(true)


func _physics_process(delta):
	if not is_instance_valid(entity.target):
		return
#	if entity.can_attack_target():
#		set_physics_process(false)
	time_since_last_interrupt += delta
	if (entity.global_position.distance_to(entity.target.global_position) < dist_to_target
			and time_since_last_interrupt > cooldown):
#
#		entity.last_attack_time
#
		time_since_last_interrupt = 0
		var action = get_node_or_null(action_path)
		if action != null:
			if DEBUG: print("interupting")
			action.emit_signal("completed", name)
#		if action is Reasoner:
#			for a in action.active_actions:
#				a.emit_signal("completed", name)
#		elif action != null:
#			if DEBUG: print("interupting")
#			action.emit_signal("completed", name)
#		else:
#			print("WARNING: failed to find target action to interupt")
