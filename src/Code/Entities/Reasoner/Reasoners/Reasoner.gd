extends ActionBase
class_name Reasoner, "res://Code/Entities/Reasoner/Reasoners/reasoner.png"


#var is_enabled = false
var active_actions = []


func _on_ready():
	._on_ready()
	for c in get_children():
		c = c as ActionBase
		if not c: continue
		c.connect("completed", self, "on_child_action_completed", [c], CONNECT_DEFERRED)
		c.connect("disabled", self, "on_child_action_disabled", [c], CONNECT_DEFERRED)
		c.connect("enabled", self, "on_child_action_enabled", [c], CONNECT_DEFERRED)
		_on_ready_child(c)


func _on_enable():
	._on_enable()
#	is_enabled = true


func _on_disable():
	._on_disable()
#	is_enabled = false
	# complete all children as well.
	for c in active_actions:
		c.emit_signal("completed", name)



func _on_ready_child(_c): pass
#To be overrided!
func _on_child_action_completed(_c): pass
func _on_child_action_disabled(_c): pass
func _on_child_action_enabled(_c): pass

 
func on_child_action_completed(err, c): 
	if c in active_actions:
		active_actions.erase(c) # keep track of active actions
		if DEBUG: 
#			if err: print("\t\t%s action was interrupted by %s!" % [c.name, err])
			print("\t%s removing %s from active actions - active actions: %s" % [name, c.name, active_actions.size()])
	if is_enabled: 
		_on_child_action_completed(c)
func on_child_action_disabled(c): 
	if is_enabled:
		 _on_child_action_disabled(c)
func on_child_action_enabled(c): 
	if is_enabled: 
		active_actions.append(c) # keep track of active actions
		if DEBUG: print("\t%s adding %s to active actions - active actions: %s" % [name, c.name, active_actions.size()])
		_on_child_action_enabled(c)

