extends Node2D

"""
positions the weapon sprite along the path, and allows it to swing along the path
"""

signal attack_finished


#export(String) var input_name = "ui_accept"
export(float) var delay_time = 0.1
export(float) var attack_time = 0.1
export(float) var attack_buffer_time = 0.1 # time we can try and attack and the attack will loop
#export(float) var damage_amt = 1


onready var path = $Path2D/PathFollow2D
onready var shape# = $Path2D/PathFollow2D/WeaponSprite/AttackArea/CollisionShape2D
onready var sprite = $Path2D/PathFollow2D/WeaponSprite as AnimatedSprite


var start_pt = 0
var end_pt = 0.99 # glitches at 1.0
var attacking = false
var attack_buffering = false


func _ready():
	var trans = get_node("Path2D/PathFollow2D/WeaponSprite/RemoteTransform2D") as RemoteTransform2D
	shape = (trans.get_node(trans.remote_path) as Area2D).get_node("CollisionShape2D")
	
	shape.disabled = true # start disabled
	$Tween.connect("tween_all_completed", self, "tween_finished")


func run_attack():
	if sprite.animation == "None":
		return
	
	# we are already attacking so check if we buffer
	if attacking: 
		# we buffer if we attacked within the attack buffer window
		if $Tween.tell() + attack_buffer_time >= $Tween.get_runtime():
			attack_buffering = true
	else:
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
	if attack_buffering:
		attack_buffering = false
		run_attack()
#	path.offset = 0

func reset_sword():
	path.offset = 0
	start_pt = 0
	end_pt = 0.99

func switch_sword(sword_name: String) -> void:
	sprite.play(sword_name)


#func _on_AttackArea_body_entered(body):
#	if body.has_method("damage"):
#		body.damage(damage_amt)
