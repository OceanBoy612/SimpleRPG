extends ActionBase
#class_name PlaySpriteAnimation


export(String) var animation_name = ""
#export(bool) var loop_anim = false


func _on_enable():
	._on_enable()
	
	if not "sprite" in get_base():
		print("WARNING: PlaySpriteAnimation failed. no sprite in base %s" % get_base().name)
		emit_signal("completed", OK)
		return
	
	var sprite: AnimatedSprite = get_base().sprite
	
	if not sprite.is_connected("animation_finished", self, "on_animation_finished"):
		sprite.connect("animation_finished", self, "on_animation_finished")
	
	sprite.frame = 0
	sprite.play(animation_name)
		


func on_animation_finished():
	if not is_processing():
		return # do nothing if we are not currently playing
	
	emit_signal("completed", OK)
