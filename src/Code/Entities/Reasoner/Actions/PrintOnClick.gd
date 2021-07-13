extends ActionBase
#class_name PrintOnSpace


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("ui_accept pressed...now disabling this state")
		emit_signal("completed", OK)
