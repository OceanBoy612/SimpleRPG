extends AnimatedSprite
class_name SmartSprite
"""
Animation handler for an AnimatedSprite as a child of a KinematicBody2D 
that has a controller that sets the direction

kb.get_meta("direction") is Vector2
scales based on the speed of the player
"""


export(bool) var DEBUG = false


onready var kb = get_parent() as KinematicBody2D
onready var anim_tree = kb.get_node("AnimationTree") as AnimationTree
onready var facing = kb.get_node("Facing") as RayCast2D


var ang_index
var suffix = "Right"
var rolling = false


func _process(delta):
	if not kb:
		print("SmartSprite requires a KinematicBody2D as a parent")
		return
	
	if not kb.has_meta("direction"):
		print("SmartSprite requires 'direction' meta variable")
		return
	
#	if kb.get_meta("direction") != Vector2.ZERO:
#		anim_tree["parameters/Idle/blend_position"] = kb.get_meta("direction")
#		anim_tree["parameters/Walk/blend_position"] = kb.get_meta("direction")
#		flip_h = kb.get_meta("direction").x < 0
#
#		anim_tree["parameters/idle_walk/blend_amount"] = 0
#	else:
#		anim_tree["parameters/idle_walk/blend_amount"] = 1
#		pass
	
#	var facingAngle = wrapf(facing.rotation, 0, PI)


	if rolling:
		pass
	else:
		var lookDirection = Vector2(cos(facing.rotation), sin(facing.rotation)).normalized()
		flip_h = lookDirection.x < 0
		ang_index = stepify( lerp(0, 4, lookDirection.y), 0.5 )

		if ang_index == 4:
			suffix = "Down"
		elif ang_index == -4:
			suffix = "Up"
		else:
			suffix = "Right"
			
		if kb.get_meta("direction") != Vector2.ZERO:
			play("Walk %s" % [suffix])
		else:
			play("Idle %s" % [suffix])


#	if kb.get_meta("direction") != Vector2.ZERO:
#		flip_h = kb.get_meta("direction").x < 0
#
#		var ang = kb.get_meta("rotation") # slightly embarassing code o_o
#		ang_index = stepify( lerp(0, 4, (ang+(1.33*PI)) / (2*PI)), 0.5 )
###		suffix = "Down" if ang_index == 3.5 else "Right"
###		suffix = "Up" if ang_index == 1.5 else suffix
	
	
	if DEBUG:
		update() # the draw method

func run_roll(direction):
	if direction == "ui_down":
		self.play("Dash Down")
	elif direction == "ui_up":
		self.play("Dash Up")
	elif direction == "ui_right":
		self.play("Dash Right")
	elif direction == "ui_left":
		self.flip_h = true
		self.play("Dash Right")
	rolling = true
	yield(self, "animation_finished")
	rolling = false

	



var default_font = Control.new().get_font("font") # just get the default font
func _draw():
	if not DEBUG:
		return 
	
	draw_string(default_font, Vector2(64, 0), animation)
	
	draw_line(Vector2(), kb.get_meta("direction").normalized()*30, Color("#ffaaff"), 2.0)
	
	draw_string(default_font, Vector2(64, 20), str(ang_index))



