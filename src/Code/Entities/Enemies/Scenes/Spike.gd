extends AttackEntity


signal spawned


onready var col1 = $CollisionShape2D
onready var col2 = $AttackArea/CollisionShape2D


func _ready():
#	$AnimatedSprite.connect("animation_finished", self, "next_anim")
	col1.set_deferred("disabled", true)
	col2.set_deferred("disabled", true)
	
	$AnimatedSprite.play("Summon")
	yield($AnimatedSprite, "animation_finished")
	emit_signal("spawned")
	$AnimatedSprite.play("Running")
	
	col1.set_deferred("disabled", false)
	col2.set_deferred("disabled", false)


func die():
	$AnimatedSprite.play("Die")
	yield($AnimatedSprite, "animation_finished")
	emit_signal("died")

