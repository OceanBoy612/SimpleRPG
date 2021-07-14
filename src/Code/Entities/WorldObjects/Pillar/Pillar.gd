extends StaticBody2D


signal down
signal up


export var lever_path: NodePath


onready var sprite: AnimatedSprite = $AnimatedSprite
onready var col: CollisionShape2D = $CollisionShape2D


func _ready():
	var lever = get_node(lever_path)
	if lever:
		lever.connect("on", self, "down")
		lever.connect("off", self, "up")



func down(): 
	sprite.play("Wind Off")
	yield(sprite, "animation_finished")
	col.set_deferred("disabled", true)
	sprite.play("Off")
	emit_signal("down")


func up(): 
	sprite.play("Wind On")
	yield(sprite, "animation_finished")
	col.set_deferred("disabled", false)
	sprite.play("On")
	emit_signal("up")



