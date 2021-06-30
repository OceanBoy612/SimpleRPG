extends Interaction
class_name DamageUpgradeInteraction


export(float) var damage_amt = 1


func interact(local_map) -> void:
	var t: CombatEntity = target as CombatEntity
	assert(t, "non combat entity interacted with the damageupgrade interaction")
	t.attack_damage += damage_amt
	
	# change sprite (not recommended but it works for now)
	var weapon: Node2D = t.get_node_or_null("Facing/Weapon")
	weapon.switch_sword("Broadsword")
	
	yield(target.get_tree().create_timer(0.1), "timeout")
	emit_signal("finished")


