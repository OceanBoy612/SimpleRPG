extends Node2D
class_name ActionBase, "res://Code/Entities/Reasoner/action_base.png"


signal completed
signal enabled
signal disabled


export var DEBUG: bool = false setget set_DEBUG


func _ready():
	_on_ready()
	if get_parent() as ActionBase:
		disable()
	else:
		enable()
	connect("completed", self, "disable")


## Override Functions ##
func _on_ready(): pass
func _on_enable(): pass
func _on_disable(): pass
#func _on_complete():
#	disable()
## Override Functions ##


func get_base():
	if get_parent() as ActionBase:
		return get_parent().get_base()
	else:
		return get_parent()


func enable():
	if DEBUG: print("%s enabled" % name)
	emit_signal("enabled")
	set_process(true)
	set_physics_process(true)
	show()
	_on_enable()
#	yield(get_tree().create_timer(max_time), "timeout")
#	emit_signal("completed")


func disable():
	if DEBUG: print("%s disabled" % name)
	set_process(false)
	set_physics_process(false)
	hide()
	_on_disable()
	emit_signal("disabled")


var default_font: Font = Control.new().get_font("font") # just get the default font
func set_DEBUG(value): # for tool if you use it
	DEBUG = value
	update()

