#tool
extends CombatEntityAction
#class_name ContextDependentSteering

"""
Steers the combat entity based on the nearby entities 
"""

export(Curve) var hostile_curve
export(Curve) var ally_curve
export(Curve) var target_curve
export(Curve) var spawn_curve

#export(int, 0, 500, 5) var distance_min = 20
#export(int, 0, 500, 5) var distance_max = 100

export var turn_speed = 0.2


var move_vectors = []
var noise = OpenSimplexNoise.new()
var _place = 0
var _noise_speed = 0.1


func _on_ready():
	._on_ready()
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
	editor_description = """Usage:
	1 means go towards, -1 means go away. 
	practically this means that this makes it try to move the entity
	towards 0.
	"""


func _on_enable():
	._on_enable()
	entity.move_dir = entity.look_dir


func _physics_process(_delta):
	if Engine.editor_hint:
		return
#	var can_attack = entity.last_attack_time >= entity.attack_cooldown
#
#	if not entity.target or not is_instance_valid(entity.target):
#		emit_signal("completed")
#		print("Bubbly")
#		return
	
	var spawn_move_dir = entity.global_position.direction_to(entity.spawn_point)
	spawn_move_dir = Vector2(1,0) if spawn_move_dir == Vector2() else spawn_move_dir
	_place += _noise_speed
	var rot = noise.get_noise_2d(_place, 0) # [-0.5, 0.5]
#	spawn_move_dir = spawn_move_dir.rotated(rot)
	var random_motion = entity.move_dir.rotated(rot) * 0.01 if entity.move_dir != Vector2() else entity.look_dir
	move_vectors = [
		map(entity.spawn_point, spawn_move_dir, "spawn"),
		random_motion
	]
	
	# for each nearby element
	for ele in entity.nearby + [entity.target]:
		if ele == null or not is_instance_valid(ele):
			continue
		
		# create a vector pointing at and away from the element
		var between = ele.global_position - global_position
		var attra: Vector2 = between.normalized()
		
		# scale that vectors between [-1, 1] based on attraction/repulsion
		attra = map(ele.global_position, attra, get_type(ele))
		
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
	
	if entity.look_dir == Vector2():
		entity.look_dir = entity.move_dir
	
	# stop steering if in range for attack
#	var in_range = entity.global_position.distance_to(entity.target.global_position) < attack_range
#	if in_range and can_attack:
#		emit_signal("completed")
	
	## DEBUG
	update()


### Helpers ###

func map(ele: Vector2, attra: Vector2, type: String) -> Vector2:
	var distance_min = 0
	var distance_max = entity.detection_radius.radius
	
	var dist = ele.distance_to(entity.global_position)
	var percent = inverse_lerp(distance_min, distance_max, clamp(dist, distance_min, distance_max))
	var curve = get("%s_curve" % type) as Curve
	var weight = curve.interpolate(percent) if curve else 0.0
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
	
	draw_string(default_font, Vector2(0, 30), str(move_vectors), Color("#ffffff"))
	
	var gizmo_rad = 10
	draw_arc(Vector2(), gizmo_rad, 0, 2*PI, 24, Color("#ff11ab"))
	
	for v in move_vectors:
		draw_line(Vector2(), v*gizmo_rad, Color("#00ff00"))
	
	var center : Vector2
	if Engine.editor_hint: center = Vector2()
	else: center = entity.spawn_point-global_position
	draw_line(Vector2(), center, Color("#abcdef"))


