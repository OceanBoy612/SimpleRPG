extends State

"""
attacks once
ends when animation finishes
"""

var anim : AnimatedSprite
export var damage_amount = 1

func on_enable():
#	anim = (kb.get_node("AnimatedSprite") as AnimatedSprite)
#	anim.connect("animation_finished", self, "on_animation_finished")
#	anim.play("Attack")
	var player = (kb.get_node("AnimationPlayer") as AnimationPlayer)
	player.play("Attack")
#	player.connect("animation_finished", "on_animation_finished")




func _on_AnimationPlayer_animation_finished(anim_name):
	(kb as CombatEntity).last_attack_time = 0
	(kb as CombatEntity).target = null
	emit_signal("completed")
	pass # Replace with function body.



func on_animation_finished():
	return 
	anim.disconnect("animation_finished", self, "on_animation_finished")
	(kb as CombatEntity).last_attack_time = 0
	(kb as CombatEntity).target = null
	anim.play("Idle")
	
	var area = (kb.get_node("AttackArea") as Area2D)
	
	var bodies = area.get_overlapping_bodies()
	for b in bodies:
		if b == kb: continue
		if b.has_method("damage"):
			b.damage(damage_amount)
		if b.has_method("knockback"):
			b.knockback(kb, damage_amount)
	
	emit_signal("completed")
	pass

### Helpers ###



### Helpers ###


### DEBUG ###

#func _draw():
#	if not DEBUG:
#		return
#
#	# TODO: This should move to the CombatEntity debug class
#	draw_arc(Vector2(), kb.attack_range, 0, 2*PI, 32, Color("#ff1111"))
#
#


