extends MultiAction
class_name OnSignal, "res://Code/Entities/Reasoner/Reasoners/interactable_action.png"


export(String) var signal_name = "interacted_with"
export(String) var name_filter = ""
export var oneshot : bool = false


func _on_ready():
	._on_ready()
	visible = false # cheeky and prob bad. but it works?
	if get_base().has_signal(signal_name):
		get_base().connect(signal_name, self, "_on_signal")
	else:
		print("WARNING: InteractableAction does nothing if it is not parented to an InteractableEntity")


func _on_signal(who):
	if is_enabled: return
	if name_filter == "" or who.name == name_filter:
		enable()
	else:
		if DEBUG:
			print("name_filter didn't match the entity (%s vs %s) that tried to interact with us. So doing nothing" % [who.name, name_filter])
	
	if oneshot:
		if get_base().is_connected(signal_name, self, "_on_signal"):
			get_base().disconnect(signal_name, self, "_on_signal")
