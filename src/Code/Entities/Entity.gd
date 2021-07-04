extends KinematicBody2D
class_name Entity


export(bool) var DEBUG = false
export var speed: float = 50.0


onready var spawn_point: Vector2 = global_position


var look_dir: Vector2 setget set_look
var move_dir: Vector2 setget set_move
var nearby: Array = []
var speed_multiplier = 1

### Vars ###

func _physics_process(delta):
	update()
	if Engine.editor_hint:
		return 
	move_and_slide(move_dir * speed * speed_multiplier)
	on_physics_process(delta)
	
func on_physics_process(_delta):
	pass

func _draw():
	if not DEBUG:
		return
	
	draw_line(Vector2(), move_dir*15, Color("#f7aa34"), 2.0)
	draw_line(Vector2(), look_dir*15, Color("#3400ff"), 2.0)
	
	for e in nearby:
		var ent = e # as Entity # cyclic 
		draw_line(Vector2(), ent.global_position-global_position, Color("#00ffaa"), 1.0)
	
	on_draw()

func on_draw():
	pass


### Setters ###

func set_look(v: Vector2) -> void:
	look_dir = v.normalized()

func set_move(v: Vector2) -> void:
	move_dir = v.normalized()
