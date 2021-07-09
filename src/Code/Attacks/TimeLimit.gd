extends Timer
class_name TimeLimit


func _ready():
	connect("timeout", self, "kill_parent")
	one_shot = false
	autostart = true
	start() # redundant... but safe :P


func kill_parent():
	var p = get_parent()
	if p is Entity:
		p.emit_signal("died")
	else:
		p.queue_free()
