extends CombatEntityAction
#class_name LookAtTarget


export(bool) var oneshot = true
export(bool) var set_move_direction = false
#export(bool) var ballistics = false
var ballistics = false # doesn't work well currently so disabling it
export(float) var time_ahead = 0.2


func _physics_process(delta):
	if is_instance_valid(entity.target):
		if ballistics: 
			look_target_ballistics()
		else:
			entity.look_dir = entity.global_position.direction_to(entity.target.position)
		
		if set_move_direction:
			entity.move_dir = entity.look_dir
	
	if oneshot:
		emit_signal("completed", OK)
	
func look_target_ballistics():
	var offset_one_sec = entity.target.move_dir * entity.target.speed * entity.target.speed_multiplier
	var offset_anim_length = offset_one_sec * time_ahead
	var dir = (entity.target.global_position - entity.global_position) + offset_anim_length
	entity.look_dir = dir.normalized()
