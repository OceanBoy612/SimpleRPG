extends Node2D

"""
positions the weapon sprite along the path, and allows it to swing along the path
"""

signal attack_finished


export(String) var input_name = "ui_accept"
export(float) var delay_time = 0.1
export(float) var attack_time = 0.1
export(float) var damage_amt = 1


onready var path = $Path2D/PathFollow2D
onready var shape = $Path2D/PathFollow2D/AttackArea/CollisionShape2D


var start_pt = 0
var end_pt = 0.99 # glitches at 1.0
var attacking = false


func _ready():
	shape.disabled = true # start disabled
	$Tween.connect("tween_all_completed", self, "tween_finished")


func run_attack():
	attacking = true
	yield(get_tree().create_timer(delay_time), "timeout")
	shape.disabled = false
	
	$Tween.interpolate_property(path, "unit_offset",
			start_pt, end_pt, attack_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	
	var temp = start_pt
	start_pt = end_pt
	end_pt = temp


func tween_finished():
	emit_signal("attack_finished")
	attacking = false
	shape.disabled = true


func _on_AttackArea_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage_amt)
