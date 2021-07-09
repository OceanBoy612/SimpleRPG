extends CombatEntityState

"""
Jumps to the targets position and releases an explosion that does damage

Uses the animation player to handle the sequence
"""

var state_machine: AnimationNodeStateMachinePlayback
var anim_player: AnimationPlayer

func on_enable():
	anim_player = kb.get_node("AnimationPlayer")
	var anim_tree: AnimationTree = kb.get_node("AnimationTree")
	state_machine = anim_tree.get("parameters/playback")
	state_machine.travel("Attack")


func attack_done():
	kb.last_attack_time = 0
	emit_signal("completed")


func move_towards_target():
	# targets where the player is.
	var dir = (kb.target.global_position - global_position)
	kb.move_dir = dir.normalized()


func move_towards_target_ballistics():
	pass
	# targets where the player will be not where he is.
	var offset_one_sec = kb.target.move_dir * kb.target.speed * kb.target.speed_multiplier
	var offset_anim_length = offset_one_sec * anim_player.get_animation("Air").length
	var dir = (kb.target.global_position - global_position) + (offset_anim_length * 1)
	kb.move_dir = dir.normalized()


func calculate_speed():
	var dir = (kb.target.global_position - global_position)
	var dash_speed = dir.length() / anim_player.get_animation("Air").length
	kb.speed_multiplier = dash_speed / kb.speed


func reset_speed():
	kb.speed_multiplier = 1
	kb.move_dir = Vector2()
