#tool
extends State
#class_name SteeringBehavior

"""
This class makes the kb wander about their starting point

gets a random direction (noise)
adds to that direction vector pointing towards the spawnpoint scaled
	by how far away from spawn the kb is
"""

export var max_distance = 200 setget set_dist
export(Curve) var curve


var noise = OpenSimplexNoise.new()
var _place = 0
var random_dir: Vector2
var home_dir: Vector2
var summed_dir: Vector2

onready var travel_dir: Vector2 = Vector2(1,0).rotated(randi() % 6)


func on_ready():
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	update()


func _physics_process(delta):
	if Engine.editor_hint:
		set_physics_process(false)
		return
	
	home_dir = kb.get_meta("spawn_point") - kb.global_position
	var normed = lerp(0, 1, home_dir.length() / max_distance)
	var attenuated = curve.interpolate(normed)
	home_dir = home_dir.normalized() * attenuated * 2.0
	
	# get random direction
	var ang = noise.get_noise_1d(_place) # [-0.5, 0.5]
	_place += 0.04
	var scaled_ang = ( (ang+0.0) ) * PI * 2 # [-PI, PI]
	
	travel_dir = travel_dir.linear_interpolate(home_dir, 0.15).normalized()
	
	summed_dir = travel_dir.rotated(scaled_ang).normalized()
	
	kb.move_and_collide(30 * summed_dir * delta)
	
	update()


func _draw():
	if not DEBUG:
		return
	
	var center : Vector2
	if Engine.editor_hint:
		center = Vector2()
	else:
		center = kb.get_meta("spawn_point")-global_position
		
	draw_line(Vector2(), home_dir*60, Color("#f7aa34"), 2.0)
	draw_line(Vector2(), summed_dir*60, Color("#f7faf4"), 2.0)
	
	draw_circle(center, 2, Color("#f7aa34"))
	
	var str_size: Vector2 = default_font.get_string_size("wander radius")
	draw_string(default_font, center+Vector2(-str_size.x/2, -max_distance), "wander radius", Color("#ff1122"))
	draw_arc(center, max_distance, 0, 2*PI, 32, Color("#ff1122"), 1.0)


### DEBUG

#
#func set_DEBUG(value):
#	.set_DEBUG(value)
	


func set_dist(value):
	max_distance = value
	update()
