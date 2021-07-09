extends ActionBase
class_name Wait

export(bool) var indefinite = false
export var time_to_wait = 1.0
var time_waiting = 0.0


func _on_enable():
	._on_enable()
	time_waiting = 0.0


func _process(delta):
	if indefinite: return
	
	time_waiting += delta
	if time_waiting > time_to_wait:
		emit_signal("completed")
