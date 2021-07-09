tool
extends CombatEntityAction
class_name ContextDependentSteering

"""
Steers the combat entity based on the nearby entities 
"""

export(Curve) var hostile_curve
export(Curve) var ally_curve
export(Curve) var target_curve

export(int, 0, 500, 5) var distance_min = 20
export(int, 0, 500, 5) var distance_max = 100

export var turn_speed = 0.2


var move_vectors = []
var noise = OpenSimplexNoise.new()
var _place = 0


func _on_ready():
	._on_ready()
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8


func _physics_process(_delta):
	if Engine.editor_hint:
		return
#	var can_attack = entity.last_attack_time >= entity.attack_cooldown
#
#	if not entity.target or not is_instance_valid(entity.target):
#		emit_signal("completed")
#		print("Bubbly")
#		return
	
	
	move_vectors = []
	
	# for each nearby element
	for ele in entity.nearby + [entity.target]:
		if ele == null or not is_instance_valid(ele):
			continue
		
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
	
	if move_vectors.size() == 0:
		print("WARNING: nothing nearby for context based steering so doing nothing")
		return
	
	# combine the vectors to one super vector
	var super_vector = Helpers.reduce(move_vectors, funcref(Helpers, "sum"))
	
	# move along super vector with noise
#	var ang = noise.get_noise_1d(_place) # [-0.5, 0.5]
#	_place += 0.14
	
#	entity.move_dir = super_vector.rotated(ang * 1.1).normalized()
	# to avoid jittering
	entity.move_dir = entity.move_dir.linear_interpolate(
			super_vector.normalized(), turn_speed)
	
	# stop steering if in range for attack
#	var in_range = entity.global_position.distance_to(entity.target.global_position) < attack_range
#	if in_range and can_attack:
#		emit_signal("completed")
	
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
	if ele == entity.target:
		return "target"
	elif ele.faction & entity.hostile_factions:
		return "hostile"
	elif ele.faction & entity.faction:
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


