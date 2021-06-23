extends Entity
class_name CombatEntity


enum Factions { 
	Player = 1,
	Neutral = 2,
	Faction1 = 4,
	Faction2 = 8,
}
export(int, FLAGS, "Player", "Neutral", "Faction1", "Faction2") var faction
export(int, FLAGS, "Player", "Neutral", "Faction1", "Faction2") var hostile_factions


var health: float = 10
var stamina: float = 10
var target = null # : CombatEntity <- except cyclic issue

var last_attack_time: float = 999
export(int) var attack_range = 25
export(float) var attack_cooldown = 1.0


func on_physics_process(delta):
	last_attack_time += delta


func on_draw():
	if target:
		draw_line(Vector2(), target.global_position-global_position, Color("#ff0000"), 1.5)





func target_nearest_enemy():
	# sets target to the nearest nearby hostile Entity if one exists
	var _target: Entity
	var max_dist: float
	for e in nearby:
		var entity = e as Entity
		
		if entity.faction & hostile_factions == 0:
			# entity is not hostile
			continue
		
		var dist = entity.global_position.distance_to(global_position)
		if not _target or dist < max_dist:
			_target = entity
			max_dist = dist
	
	if _target:
		print("Targeting: %s" % _target.name)
		target = _target
		return true
	else:
		print("No hostile targets found")
		return false
