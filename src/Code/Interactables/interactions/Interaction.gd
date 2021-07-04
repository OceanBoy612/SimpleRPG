# Base command interface for all actions the player 
# or a character can perform on the map
# Uses a reference to the LocalMap to start interactions
# and wait for events to complete with coroutines
extends Resource
class_name Interaction


signal finished
var active: bool = true
var target : Entity 


func set_target(t: Entity):
	target = t


func interact(_local_map) -> void:
	print("You forgot to override the interact method in an Interaction")
	emit_signal("finished")
