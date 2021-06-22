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


func _process(delta):
	if not kb:
		print("SmartSprite requires a KinematicBody2D as a parent")
		return
	
	if not kb.has_meta("direction"):
		print("SmartSprite requires 'direction' meta variable")
		return
	
	if kb.get_meta("direction") != Vector2.ZERO:
		anim_tree["parameters/Idle/blend_position"] = kb.get_meta("direction")
		anim_tree["parameters/Walk/blend_position"] = kb.get_meta("direction")
		flip_h = kb.get_meta("direction").x < 0
		
		anim_tree["parameters/idle_walk/blend_amount"] = 0
	else:
		anim_tree["parameters/idle_walk/blend_amount"] = 1
		pass
	
#	if kb.get_meta("direction") != Vector2.ZERO:
#		flip_h = kb.get_meta("direction").x < 0
#		play("Walk")
#	else:
#		play("Idle")
	
	if DEBUG:
		update() # the draw method


var default_font = Control.new().get_font("font") # just get the default font
func _draw():
	if DEBUG:
		draw_string(default_font, Vector2(64, 0), animation)






