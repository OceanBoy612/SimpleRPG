extends Node2D
class_name State


signal completed


export var DEBUG: bool = false setget set_DEBUG


var kb: Entity
var default_font: Font = Control.new().get_font("font") # just get the default font


func _ready():
	disable()
	on_ready()


func on_ready():
	pass

func on_enable():
	pass

func enable(_kb: Entity, max_time: float):
	set_process(true)
	set_physics_process(true)
	show()
	kb = _kb
	on_enable()
	yield(get_tree().create_timer(max_time), "timeout")
	emit_signal("completed")


func disable():
	set_process(false)
	set_physics_process(false)
	if kb:
		kb.move_dir = Vector2()
	hide()


func set_DEBUG(value):
	DEBUG = value
	update()

### Helpers ###


	
