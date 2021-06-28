extends CombatEntityState

"""
attacks once
ends when animation finishes
"""

#export var damage_amount = 1


var anim : AnimatedSprite

var dir : Vector2
var vel : float
var vel2 : float

var dash_speed = 125
var jump_duration = 0.4
var jump_height = 300
var attack_delay = 0.6


func on_enable():
	anim = (kb.get_node("AnimatedSprite") as AnimatedSprite)
	if not anim.is_connected("animation_finished", self, "on_animation_finished"):
		anim.connect("animation_finished", self, "on_animation_finished")
	anim.play("Leap")
	
#	$Tween.interpolate_property(self, "vel",  dash_speed, 0, jump_duration, Tween.TRANS_LINEAR, Tween.EASE_IN, attack_delay)
	$Tween.interpolate_property(self, "vel",  dash_speed, dash_speed, jump_duration, Tween.TRANS_LINEAR, Tween.EASE_IN, attack_delay)
	$Tween.interpolate_property(self, "vel2", jump_height, -jump_height, jump_duration, Tween.TRANS_LINEAR, Tween.EASE_IN, attack_delay)
	$Tween.start()
	dir = (kb.target.global_position - global_position).normalized()
	
	# disable collision
	kb.collision_mask = kb.collision_mask & ~1 # World layer
	kb.collision_mask = kb.collision_mask & ~2 # Player layer
	kb.collision_mask = kb.collision_mask & ~4 # Enemy layer
	
	
#	var player = (kb.get_node("AnimationPlayer") as AnimationPlayer)
#	player.play("Attack")
#	player.connect("animation_finished", "on_animation_finished")


func _physics_process(delta):
	kb.move_and_slide(vel * dir)
	kb.move_and_slide(vel2 * Vector2(0, -1))
	pass





func on_animation_finished():
	if anim.animation == "Leap":
		anim.play("Air")
	elif anim.animation == "Detonate":
		anim.disconnect("animation_finished", self, "on_animation_finished")
		anim.play("Idle")
		kb.last_attack_time = 0
		kb.target = null
		
		emit_signal("completed")
	
	



func _on_Tween_tween_all_completed():
	anim.play("Detonate")
	
	vel = 0
	vel2 = 0
	
	var pl = kb.get_node("AnimationPlayer") as AnimationPlayer
	pl.play("Attack") # aoe damage area expansion and enable
	
	# re-enable collision
	kb.collision_mask = kb.collision_mask | 1 # World layer
	kb.collision_mask = kb.collision_mask | 2 # Player layer
	kb.collision_mask = kb.collision_mask | 4 # Enemy layer









