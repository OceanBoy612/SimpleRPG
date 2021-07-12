extends MultiAction
class_name InteractableAction


export(String) var name_filter = ""


func _on_ready():
	._on_ready()
	visible = false # cheeky and prob bad. but it works?
	if get_base().has_signal("interacted_with"):
		get_base().connect("interacted_with", self, "_on_interaction")
	else:
		print("WARNING: InteractableAction does nothing if it is not parented to an InteractableEntity")


func _on_interaction(who: Entity):
	if is_enabled: return
	if name_filter == "" or who.name == name_filter:
		enable()
	else:
		if DEBUG:
			print("name_filter didn't match the entity that tried to interact with us. So doing nothing")
