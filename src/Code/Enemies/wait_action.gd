extends State


var wait_time = 1
var curr_time = 0


func _physics_process(delta):
	curr_time += delta
	update()
	if curr_time >= wait_time:
		curr_time = 0
		emit_signal("completed")
		




func _draw():
	if not DEBUG: return
	# draws the time remaining
	draw_string(default_font, Vector2(0, -64), 
			"waiting: %.2f" % [wait_time-curr_time], 
			Color("#ffff00"))
