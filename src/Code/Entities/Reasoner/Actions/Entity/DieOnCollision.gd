extends EntityAction
class_name DieOnCollision


func _physics_process(delta):
	if entity.get_slide_count() > 0:
		entity.emit_signal("died")
		emit_signal("completed", OK)
