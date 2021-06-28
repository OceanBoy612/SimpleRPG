extends CombatEntityState


"""
uses the kb's 'nearby' array to determine context dependent steering
can be used to create strafing, running, etc...
"""

export(float) var attack_range = 20

export(Curve) var hostile_curve
export(Curve) var ally_curve
export(Curve) var target_curve

export(int, 0, 500, 5) var distance_min = 20
export(int, 0, 500, 5) var distance_max = 100


var move_vectors = []

var noise = OpenSimplexNoise.new()
var _place = 0

func on_ready():
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

#func on_enable():
#	kb.target_nearest_enemy()


func _physics_process(delta):
	var can_attack = kb.last_attack_time >= kb.attack_cooldown
	
	if not kb.target or not is_instance_valid(kb.target):
		emit_signal("completed")
		print("Bubbly")
		return
	
	
	
	move_vectors = []
	
	# for each nearby element
	for ele in kb.nearby + [kb.target]:
		
		# create a vector pointing at and away from the element
		var between = ele.global_position - global_position
		var attra: Vector2 = between.normalized()
		
		# scale that vectors between [-1, 1] based on attraction/repulsion
		attra = map(ele, attra, get_type(ele))
		
		# reverse the target attraction if can't attack
#		if not can_attack:
#			attra *= -1
		
		# add to arrays
		move_vectors.append(attra)
	
	# combine the vectors to one super vector
	var super_vector = Helpers.reduce(move_vectors, funcref(Helpers, "sum"))
	
	# move along super vector with noise
	var ang = noise.get_noise_1d(_place) # [-0.5, 0.5]
	_place += 0.14
	kb.move_dir = super_vector.rotated(ang * 1.1).normalized()
	
	# stop steering if in range for attack
	var in_range = kb.global_position.distance_to(kb.target.global_position) < attack_range
	if in_range and can_attack:
		emit_signal("completed")
	
	## DEBUG
	update()

### Helpers ###

func map(ele, attra: Vector2, type: String) -> Vector2:
	var dist = ele.global_position.distance_to(global_position)
	var percent = inverse_lerp(distance_min, distance_max, clamp(dist, distance_min, distance_max))
	var curve = get("%s_curve" % type) as Curve
#	var curve = get("target_curve") as Curve
	var weight = curve.interpolate(percent)
	return attra * weight

###

func get_type(ele) -> String:
	if ele == kb.target:
		return "target"
	elif ele.faction & kb.hostile_factions:
		return "enemy"
	elif ele.faction & kb.faction:
		return "ally"
	else:
		return "neutral"


### DEBUG ###

func _draw():
	if not DEBUG:
		return
	
	var gizmo_rad = 10
	draw_arc(Vector2(), gizmo_rad, 0, 2*PI, 24, Color("#ff11ab"))
	
	for v in move_vectors:
		draw_line(Vector2(), v*gizmo_rad, Color("#00ff00"))


