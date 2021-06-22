extends State
#class_name SteeringBehavior


"""
This class makes the kb wander about their starting point

gets a random direction (noise)
adds to that direction vector pointing towards the spawnpoint scaled
	by how far away from spawn the kb is
"""

export var max_distance = 200
export(Curve) var curve


var noise = OpenSimplexNoise.new()
var _place = 0
var random_dir: Vector2
var home_dir: Vector2
var summed_dir: Vector2

func on_ready():
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8


func _physics_process(delta):
	
	home_dir = kb.get_meta("spawn_point") - kb.global_position
	var normed = lerp(0, 1, home_dir.length() / max_distance)
	var attenuated = curve.interpolate(normed)
	home_dir = home_dir.normalized() * attenuated * 1.1
	
	# get random direction
	while true:
		var ang = noise.get_noise_1d(_place) # [-0.5, 0.5]
		_place += 0.02
		var scaled_ang = ( (ang+0.5) ) * 6 * PI # [0, 4?PI]
		random_dir = Vector2(1,0).rotated(scaled_ang)
#		print(ang)
		if home_dir.dot(random_dir) > -0.7:
			print(_place)
			break
	
	
	
	summed_dir = home_dir + random_dir
	summed_dir = summed_dir.normalized()
	
	kb.move_and_collide(100 * summed_dir * delta)
	
	update()


func _draw():
	if not DEBUG:
		return
	draw_string(default_font, Vector2(0, -64), "dot: %.3f" % [home_dir.dot(random_dir)], Color("#ffaaff"))
	
	draw_line(Vector2(), random_dir*60, Color("#00ff67"), 2.0)
	draw_line(Vector2(), home_dir*60, Color("#f7aa34"), 2.0)
	draw_line(Vector2(), summed_dir*60, Color("#f7faf4"), 2.0)
	var center = kb.get_meta("spawn_point")-global_position
	draw_circle(center, 6, Color("#f7aa34"))
	draw_arc(center, max_distance, 0, 2*PI, 24, Color("#ff1122"), 1.5)
