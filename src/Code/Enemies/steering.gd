extends State


"""
uses the kb's 'nearby' array to determine context dependent steering
can be used to create strafing, running, etc...
"""


export(Curve) var hostile_curve
export(int, 0, 500, 5) var enemy_min = 20
export(int, 0, 500, 5) var enemy_max = 100

export(Curve) var neutral_curve
export(int, 0, 500, 5) var neutral_min = 20
export(int, 0, 500, 5) var neutral_max = 100

export(Curve) var ally_curve
export(int, 0, 500, 5) var ally_min = 20
export(int, 0, 500, 5) var ally_max = 100

export(Curve) var target_curve
export(int, 0, 500, 5) var target_min = 20
export(int, 0, 500, 5) var target_max = 100


var attra_vectors = []
var repel_vectors = []

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
	pass
	var ckb = kb as CombatEntity
	var can_attack = ckb.last_attack_time >= ckb.attack_cooldown
	
	attra_vectors = []
	repel_vectors = []
	
	# for each nearby element
	for ele in ckb.nearby + [ckb.target]:
		pass
		# create a vector pointing at and away from the element
		var between = ele.global_position - global_position
		var attra: Vector2 = between.normalized()
#		var repel: Vector2 = between.normalized().rotated(PI)
		# scale that vectors between [0, 1] based on attraction/repulsion
		attra = map_far(ele, attra, get_type(ele))
		
		# reverse the target attraction if can't attack
		if not can_attack:
			attra *= -1
		
		# add to arrays
		attra_vectors.append(attra)
#		repel_vectors.append(repel)
	
	# combine the vectors to one super vector
	var super_vector = Helpers.reduce(attra_vectors, funcref(Helpers, "sum"))
	# move along super vector with noise
	var ang = noise.get_noise_1d(_place) # [-0.5, 0.5]
	_place += 0.14
	kb.move_dir = super_vector.rotated(ang * 1.1).normalized()
	# stop steering if in range for attack
	var in_range = ckb.global_position.distance_to(ckb.target.global_position) < ckb.attack_range
	if in_range and can_attack:
		kb.move_dir = Vector2() # TODO: stop moving when change state by default?
		emit_signal("completed")
	## DEBUG
	update()

### Helpers ###

func map_far(ele, attra: Vector2, type: String) -> Vector2:
	var dist = ele.global_position.distance_to(global_position)
	var percent = inverse_lerp(target_min, target_max, clamp(dist, target_min, target_max))
	var curve = get("%s_curve" % type) as Curve
	var weight = curve.interpolate(percent)
	return attra * weight

###

func get_type(ele) -> String:
	var c_kb: CombatEntity = kb as CombatEntity
	
	if ele == c_kb.target:
		return "target"
	elif ele.faction & c_kb.hostile_factions:
		return "enemy"
	elif ele.faction & c_kb.faction:
		return "ally"
	else:
		return "neutral"


### DEBUG ###

func _draw():
	if not DEBUG:
		return
	
	var gizmo_rad = 10
	draw_arc(Vector2(), gizmo_rad, 0, 2*PI, 24, Color("#ff11ab"))
	
	for v in attra_vectors:
		draw_line(Vector2(), v*gizmo_rad, Color("#00ff00"))
	for v in repel_vectors:
		draw_line(Vector2(), v*gizmo_rad, Color("#ff0000"))


