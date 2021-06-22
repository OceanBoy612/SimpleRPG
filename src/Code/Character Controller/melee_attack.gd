extends Area2D

"""
an area that enables itself briefly during an attack

TODO: add a delay to this OR move all animations to an animationplayer
"""


export(String) var input_name = "ui_accept"
export(float) var delay_time = 0.1
export(float) var activation_duration = 0.1

export(float) var damage_amt = 1

var attacking = false


func _ready():
	$CollisionShape2D.disabled = true # start disabled


#func _input(event):
#	if event.is_action_pressed(input_name):
#		yield(get_tree().create_timer(delay_time), "timeout")
#		$CollisionShape2D.disabled = false
#		yield(get_tree().create_timer(activation_duration), "timeout")
#		$CollisionShape2D.disabled = true


func _on_AttackArea_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage_amt)


func run_attack():
	attacking = true
	yield(get_tree().create_timer(delay_time), "timeout")
	$CollisionShape2D.disabled = false
	yield(get_tree().create_timer(activation_duration), "timeout")
	$CollisionShape2D.disabled = true
	attacking = false
