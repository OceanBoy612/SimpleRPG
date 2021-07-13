tool
extends Entity
class_name CombatEntity


signal killed(what) # when i kill something else
signal health_changed(new_health, max_health)
signal attacked
#signal mana_changed(new_mana, max_mana)


export(String) var type # the name of the entity (player, frim etc...)

export(Resource) var _inventory
onready var inventory: Inventory = _inventory as Inventory

export(int, FLAGS, "Player", "Neutral", "Faction1", "Faction2") var faction
export(int, FLAGS, "Player", "Neutral", "Faction1", "Faction2") var hostile_factions

export(float) var attack_damage = 1.0
#export(NodePath) var attack_area_path
var attack_area: Area2D # set elsewhere

export var max_health: float = 10
var health: float = max_health
#export var max_mana: float = 10
#var mana: float = max_mana

var target = null # : CombatEntity <- except cyclic issue
export var iframes = 0.0 # time spent immortal after taking damage
export var immortal = false # can take damage

export(float) var attack_cooldown = 1.0
export(float) var attack_range = 50
var last_attack_time: float = 999

var knockback_amt = 0
var knockback_percent = 0.2
var knockback_dir: Vector2
export(float) var knockback_amount = 1000

#export(PackedScene) var SpawnAttack

### Overrides ###


func on_physics_process(delta):
	# handle attack cooldown
	last_attack_time += delta
	
	# handle knockback
	move_and_slide(knockback_amt * knockback_percent * knockback_dir)
	knockback_amt *= 1-knockback_percent


func on_draw():
	if is_instance_valid(target):
		draw_line(Vector2(), _vec_to_target(), Color("#ff0000"), 1.5)
	

### Overrides ###
### Helpers ###


func damage_entity(body: PhysicsBody2D, damage_override: float=0, knockback_override:float=0):
	# only damage hostile factions
	var b = body as CombatEntity
	if not b: return
	if b.faction & hostile_factions == 0: return  # entity not hostile
	if b.immortal: return # don't hurt immortal entities
	
	if body.has_method("knockback"):
		if knockback_override:
			body.knockback(self, knockback_override)
		else:
			body.knockback(self, knockback_amount)
	if body.has_method("damage"):
		var killed = body.damage(damage_override) if damage_override else body.damage(attack_damage)
		
		if killed:
			_increment_killed(body)


func heal(amt) -> bool:
	return damage(-amt)

# Returns true if the entity dies, false otherwise
func damage(amt) -> bool:
	health -= amt
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health, max_health)
	
	if health > 0 and amt > 0:
		_flash_white()
	
	if health <= 0:
		emit_signal("died")
		return true
	
	return false


func knockback(source: Node2D, amt: float):
	# push self away from source
	knockback_amt = amt
	knockback_dir = (source.global_position-global_position).normalized() * -1
#	_vec_to_target().normalized() * -1

export(bool) var create_new_loot_table setget create_loottable
export(Resource) var lootTable
func create_loottable(v):
	if v == false: return
	if lootTable != null: return 
	var a = LootTable.new()
	a.resource_name = "Loot Table"
	lootTable = a
	property_list_changed_notify()



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
		if DEBUG:
			print("Targeting: %s" % _target.name)
		target = _target
		return true
	else:
		if DEBUG:
			print("No hostile targets found")
		return false


func spawn_attack(_index:int=0):
	$AttackPattern.spawn_attack()
	emit_signal("attacked")
	pass
#	var spawnAttack = SpawnAttack.instance()
#	assert(spawnAttack.has_method("init_attack"), "Trying to attack with a non attack")
#	spawnAttack.init_attack(self)
#	print("Spawning Attack")
#	$Attacks.add_child(spawnAttack)

func can_attack_target() -> bool:
	if not is_instance_valid(target):
		return false
	return last_attack_time > attack_cooldown \
			and global_position.distance_to(target.global_position) < attack_range


func is_hostile(other: CombatEntity): return other.faction & hostile_factions
func is_ally(other: CombatEntity): return other.faction & faction 


### Helpers ###
### Subroutines ###


func _vec_to_target() -> Vector2:
	if not is_instance_valid(target):
		return Vector2()
	return target.global_position-global_position


func _flash_white():
	immortal = true
	modulate = Color(10,10,10,10)
	yield(get_tree().create_timer(0.1), "timeout")
	modulate = Color(1,1,1,1)
	# TODO: move this to animation player?
	if iframes > 0:
		yield(get_tree().create_timer(iframes), "timeout") 
	immortal = false


func _get_killed_id(what) -> String:
	return "%s_killed" % what.type


func _increment_killed(what) -> void:
	var id = _get_killed_id(what)
	if not has_meta(id):
		set_meta(id, 0)
	set_meta(id, get_meta(id) + 1)
	emit_signal("killed", what)

func _num_killed(what) -> int:
	var id = _get_killed_id(what)
	if not has_meta(id):
		return 0
	return get_meta(id)


func on_death():
	if lootTable:
		(lootTable as LootTable).spawn_loot(self)
	.on_death()

### Subroutines ###








