extends Entity
class_name CombatEntity


signal died


enum Factions { 
	Player = 1,
	Neutral = 2,
	Faction1 = 4,
	Faction2 = 8,
}
export(int, FLAGS, "Player", "Neutral", "Faction1", "Faction2") var faction
export(int, FLAGS, "Player", "Neutral", "Faction1", "Faction2") var hostile_factions

export(float) var attack_cooldown = 1.0
export(float) var attack_damage = 1.0
export(NodePath) var attack_area_path


var health: float = 10
var target = null # : CombatEntity <- except cyclic issue

var last_attack_time: float = 999

var knockback_amt = 0
var knockback_percent = 0.2
var knockback_dir: Vector2
export(float) var knockback_amount = 1000

### Overrides ###


func _ready():
	var area = get_node_or_null(attack_area_path)
	if area:
		area.connect("body_entered", self, "damage_entity")


func on_physics_process(delta):
	# handle attack cooldown
	last_attack_time += delta
	
	# handle knockback
	move_and_slide(knockback_amt * knockback_percent * knockback_dir)
	knockback_amt *= 1-knockback_percent


func on_draw():
	if is_instance_valid(target):
		draw_line(Vector2(), target.global_position-global_position, Color("#ff0000"), 1.5)


### Overrides ###
### Helpers ###


func damage_entity(body: PhysicsBody2D):
	# only damage hostile factions
	var b = body as CombatEntity
	if not b: return
	if b.faction & hostile_factions == 0: return  # entity not hostile
	
	if body.has_method("damage"):
		body.damage(attack_damage)
	if body.has_method("knockback"):
		body.knockback(self, knockback_amount)


func damage(amt):
	health -= amt
	_flash_white()
	if health <= 0:
		emit_signal("died")
		queue_free()


func knockback(source: Node2D, amt: float):
	# push self away from source
	knockback_amt = amt
	knockback_dir = (global_position - source.global_position).normalized()


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


### Helpers ###
### Subroutines ###


func _flash_white():
	modulate = Color(10,10,10,10)
	yield(get_tree().create_timer(0.1), "timeout")
	modulate = Color(1,1,1,1)


### Subroutines ###
