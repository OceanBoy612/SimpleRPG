# Base command interface for all actions the player 
# or a character can perform on the map
# Uses a reference to the LocalMap to start interactions
# and wait for events to complete with coroutines
extends Resource
class_name Interaction


signal finished
#var local_map
var active: bool = true


#func _ready() -> void:
#	# using a group so LocalMap can initialize all Interactions
#	add_to_group("interaction")


#func initialize(_local_map):
#	local_map = _local_map


func interact(local_map) -> void:
	print("You forgot to override the interact method in an Interaction")
	emit_signal("finished")
