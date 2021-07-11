extends EntityAction
class_name WaitUntilAnimationFrame


export(int) var anim_frame = 0
var time_chugging = 0


func _process(delta):
	var clamped_limit = min(anim_frame, entity.sprite.frames.get_frame_count(entity.sprite.animation)-1)
	if entity.sprite.frame >= clamped_limit:
		emit_signal("completed", OK)
	
	# just in case
	time_chugging += delta
	assert(time_chugging < 5, "WaitUntilAnimationFrame took longer then 5 seconds to complete")
	
