extends ActionBase
class_name Reasoner, "res://Code/Entities/Reasoner/Reasoners/reasoner.png"

var is_enabled = false

func _on_ready():
	._on_ready()
	for c in get_children():
		c = c as ActionBase
		if not c: continue
		c.connect("completed", self, "on_child_action_completed", [c])
		c.connect("disabled", self, "on_child_action_disabled", [c])
		c.connect("enabled", self, "on_child_action_enabled", [c])
		_on_ready_child(c)


func _on_enable():
	._on_enable()
	is_enabled = true


func _on_disable():
	._on_disable()
	is_enabled = false
	# complete all children as well.
	for c in get_children():
		c = c as ActionBase
		if not c: continue
		c.emit_signal("completed")



func _on_ready_child(c): pass

func _on_child_action_completed(c): pass
func _on_child_action_disabled(c): pass
func _on_child_action_enabled(c): pass

# make sure that 
func on_child_action_completed(c): if is_enabled: _on_child_action_completed(c)
func on_child_action_disabled(c): if is_enabled: _on_child_action_disabled(c)
func on_child_action_enabled(c): if is_enabled: _on_child_action_enabled(c)
