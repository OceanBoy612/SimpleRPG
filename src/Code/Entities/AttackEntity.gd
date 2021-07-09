extends CombatEntity
class_name AttackEntity


export(Vector2) var offset = Vector2()


var creator # another CombatEntity that spawned this entity


func init_attack(c):
	creator = c
	faction = c.faction
	hostile_factions = c.hostile_factions
	target = c.target


func _increment_killed(what) -> void:
	creator._increment_killed(what)
