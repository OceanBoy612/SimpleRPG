extends State

"""
This state chooses the closest target.
walks up to it
attacks once
ends
"""

var target
var speed = 30
var dir: Vector2
export var attack_range = 30

func on_enable():
	# choose the closest target
	target = null
	if kb.has_meta("nearby"):
		var max_dist: float
		for entity in kb.get_meta("nearby"):
			var dist = entity.global_position.distance_to(global_position)
			if not target or dist < max_dist:
				target = entity
				max_dist = dist
	assert(target, "no target for attack found")
	print("TARGET FOUND: %s" % target.name)


func _physics_process(delta):
	if Engine.editor_hint:
		set_physics_process(false)
		return
	
	# walk towards the target
	dir = target.global_position-global_position
	kb.move_and_collide(dir.normalized() * delta * speed)
	# when within range attack
	if dir.length() < attack_range:
		emit_signal("completed")
	
	update()


### Helpers ###



### Helpers ###


### DEBUG ###

func _draw():
	if not DEBUG:
		return
	
	draw_line(Vector2(), dir, Color("#abcdef"))
	draw_arc(Vector2(), attack_range, 0, 2*PI, 32, Color("#ff1111"))


