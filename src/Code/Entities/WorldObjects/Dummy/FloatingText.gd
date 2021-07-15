extends Node2D


onready var label: Label = $Label
onready var tween: Tween = $Tween
var amount = 0


func _ready():
	label.text = str(amount)
	tween.connect("tween_all_completed", self, "done")
	var dir: Vector2 = Vector2(0,-1).rotated(rand_range(-PI / 4, PI / 4))
	var magnitude = rand_range(10, 20)
	tween.interpolate_property(self, "position", position, position + dir * magnitude, 
			1.0, Tween.TRANS_QUART, Tween.EASE_OUT)
	var c: Color = modulate
	var new_c = c
	new_c.a = 0.0
	tween.interpolate_property(self, "modulate", c, new_c, 
			1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
	pass
	
func done():
	queue_free()
	
