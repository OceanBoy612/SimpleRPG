extends CombatEntityAction
class_name SpawnAttack


export(int) var which = 0


func _on_enable():
	._on_enable()
	entity.spawn_attack(which)
	emit_signal("completed")


