extends Node2D
class_name State


signal completed


export var DEBUG = false


var kb: KinematicBody2D
var default_font = Control.new().get_font("font") # just get the default font


func _ready():
	disable()
	on_ready()


func on_ready():
	pass


func enable(_kb: KinematicBody2D, max_time: float):
	set_process(true)
	set_physics_process(true)
	show()
	kb = _kb
	yield(get_tree().create_timer(max_time), "timeout")
	emit_signal("completed")


func disable():
	set_process(false)
	set_physics_process(false)
	hide()

