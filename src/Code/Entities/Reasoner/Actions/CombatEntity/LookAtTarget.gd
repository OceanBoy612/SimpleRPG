extends CombatEntityAction
class_name LookAtTarget


export(bool) var oneshot = true
export(bool) var set_move_direction = false


func _physics_process(delta):
	if is_instance_valid(entity.target):
		entity.look_dir = entity.global_position.direction_to(entity.target.position)
		if set_move_direction:
			entity.move_dir = entity.look_dir
	if oneshot:
		emit_signal("completed", OK)
	
