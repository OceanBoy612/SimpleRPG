extends Reasoner


var state : ActionBase
var ind = 0
var entity : CombatEntity

func _on_enable():
	._on_enable()
	entity = get_base()
	choose_next_action()


func choose_next_action():
	if entity.can_attack_target():
		state = get_node("Attack")
		state.enable()
	else:
		state = get_node("StrafeTowards")
		state.enable()


#func _on_disable():
#	._on_disable()
##	yield(get_tree().create_timer(0.5), "timeout")
#	self.enable() # restart if we die


func _on_child_action_completed(c):
#	print("reasoner can attack?: %s. Action complete %s" % [entity.can_attack_target(), c.name])
	print("CHOOSING NEXT ACTION")
	choose_next_action()
		


func _input(event):
	if event.is_action_pressed("ui_accept"):# and state.name == "StrafeTowards":
		print("\nHIHI, %s interrupting %s\n" % [name, state.name])
#		is_enabled = false
#		state.emit_signal("completed", name) # simulate an interrupt
#		set_deferred("is_enabled", true)
#		call_deferred("choose_next_action")
		
		turn_off_and_on()
		
