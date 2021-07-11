extends Node2D
class_name ActionBase, "res://Code/Entities/Reasoner/action_base.png"


signal completed
signal enabled
signal disabled


export var DEBUG: bool = false setget set_DEBUG


var is_enabled = true


func _ready():
	_on_ready()
	var manual_disable = not visible
	disable()
	connect("completed", self, "disable")
	if manual_disable:
		print("DEBUG: DISABLING %s BECAUSE IT IS NOT VISIBLE IN THE TREE. IF THIS IS NOT INTENDED MAKE SURE TO MAKE THE NODE VISIBLE ON STARTUP." % name)
		return
	if get_parent() as ActionBase == null:
		get_base().connect("ready", self, "enable")
#		enable()


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
	if is_enabled:
		print("\t\tEnabling an action that was already enabled %s" % name)
		return
	if DEBUG: print("%s enabled" % name)
	emit_signal("enabled")
	set_process(true)
	set_physics_process(true)
	show()
	is_enabled = true
	_on_enable()
#	yield(get_tree().create_timer(max_time), "timeout")
#	emit_signal("completed", OK)


func disable(err=OK):
	if not is_enabled:
		print("\t\tDisabling an action that wasn't enabled %s" % name)
		return 
	if DEBUG: 
		
		if not err: print("%s disabled" % name)
		else: print("%s interrupted by %s!" % [name, err])
	set_process(false)
	set_physics_process(false)
	hide()
	_on_disable()
	is_enabled = false
	emit_signal("disabled")


var default_font: Font = Control.new().get_font("font") # just get the default font
func set_DEBUG(value): # for tool if you use it
	DEBUG = value
	update()


func turn_off_and_on():
	emit_signal("completed")
	call_deferred("enable")
