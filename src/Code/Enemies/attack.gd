extends State

"""
attacks once
ends when animation finishes
"""

export var damage_amount = 1
var anim : AnimatedSprite


var dir : Vector2
var vel : float

var jump_duration = 0.4

func on_enable():
	anim = (kb.get_node("AnimatedSprite") as AnimatedSprite)
	if not anim.is_connected("animation_finished", self, "on_animation_finished"):
		anim.connect("animation_finished", self, "on_animation_finished")
	anim.play("Leap")
	
#
	$Tween.interpolate_property(self, "vel", 
			250, 0, jump_duration, Tween.TRANS_SINE, Tween.EASE_IN, 0.6)
	$Tween.start()
	dir = ((kb as CombatEntity).target.global_position - global_position).normalized()
	
	# disable collision
	kb.collision_mask = kb.collision_mask & ~2 # Player layer
	kb.collision_mask = kb.collision_mask & ~4 # Enemy layer
	
	
#	var player = (kb.get_node("AnimationPlayer") as AnimationPlayer)
#	player.play("Attack")
#	player.connect("animation_finished", "on_animation_finished")


func _physics_process(delta):
	kb.move_and_slide(vel * dir)
	pass





func on_animation_finished():
	if anim.animation == "Leap":
		anim.play("Air")
	elif anim.animation == "Detonate":
		anim.disconnect("animation_finished", self, "on_animation_finished")
		anim.play("Idle")
		(kb as CombatEntity).last_attack_time = 0
		(kb as CombatEntity).target = null
		
		emit_signal("completed")
	
	



func _on_Tween_tween_all_completed():
	anim.play("Detonate")
	
	var pl = kb.get_node("AnimationPlayer") as AnimationPlayer
	pl.play("Attack") # aoe damage area expansion and enable
	
	# re-enable collision
	kb.collision_mask = kb.collision_mask | 2 # Player layer
	kb.collision_mask = kb.collision_mask | 4 # Enemy layer









