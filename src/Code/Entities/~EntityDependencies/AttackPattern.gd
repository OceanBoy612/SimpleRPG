extends Node


export(PackedScene) var attack

export(int) var number = 1
export(String, "self", "target") var source = "self"

export(float, 0, 360, 5) var spread = 0 # size of cone from look_dir
export(float, 0, 360, 5) var rot_spread = 0 # size of cone

export(Vector2) var offset = Vector2() # relative to look_dir (as x-axis)
export(Vector2) var offset_spread = Vector2() # relative to look_dir X axis (y is up-down)


onready var kb = get_parent() as CombatEntity


func spawn_attack():
	var degrees = get_degrees()
	for i in range(number):
		
		var spawnAttack: AttackEntity = attack.instance()
		assert(spawnAttack.has_method("init_attack"), "Trying to attack with a non attack")
		spawnAttack.init_attack(kb)
		
		var relative = kb if source == "self" else kb.target
		
		var _offset_spread = rand_range_vec2(offset_spread)
		var _rot_spread = deg2rad( rand_range(-rot_spread/2, rot_spread/2) )
		
		spawnAttack.global_position = relative.global_position
		spawnAttack.rotation = relative.look_dir.angle() + degrees[i] + _rot_spread
		
		spawnAttack.position += (offset + _offset_spread).rotated(spawnAttack.rotation)
		
		add_child(spawnAttack)
		
	kb.last_attack_time = 0
		
#	print("Spawning Attack")
	pass


func rand_range_vec2(vec: Vector2) -> Vector2:
	return Vector2(rand_range(-vec.x/2, vec.x/2), rand_range(-vec.y/2, vec.y/2))


func get_degrees() -> Array:
	# number = 5, spread = 10, returns [-10.0, -5.0, 0.0, 5.0, 10.0]
	if number == 1:
		return [0.0]
	var output = []
	var s = spread/2
	var n = number if int(spread) == 360 else number - 1 # at 360 will go to nova mode
	for x in range(number):
		output.append(deg2rad( (-s) + x*(s-(-s))/(n)) )
	return output
