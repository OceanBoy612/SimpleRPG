extends EntityAction
class_name PlaySpriteAnimation


export(String) var animation_name = ""
export(bool) var loop_anim = false


func _on_enable():
	._on_enable()
	
	if not entity.sprite.is_connected("animation_finished", self, "on_animation_finished"):
		entity.sprite.connect("animation_finished", self, "on_animation_finished")
	
	entity.sprite.frame = 0
	entity.sprite.play(animation_name)
#	print(entity.sprite.frames.get_frame_count(animation_name))
#	if entity.sprite.frames.get_frame_count(animation_name) == 1:
#		print("1 length animation")
		


func _on_disable():
	._on_disable()
#	if entity:
#		entity.sprite.playing = false
#		entity.sprite.frame = 0
	


func on_animation_finished():
	if not is_processing():
		return # do nothing if we are not currently playing
#	if loop_anim:
#		# should we restart the animation here?
##		entity.sprite.frame = 0
#		return 
#	if entity.sprite.animation == animation_name:
	emit_signal("completed", OK)
