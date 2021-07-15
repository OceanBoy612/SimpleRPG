extends StaticBody2D


onready var sprite : AnimatedSprite = $AnimatedSprite
onready var text = preload("res://Code/Entities/WorldObjects/Dummy/FloatingText.tscn")


func _ready():
	sprite.play("Idle")


func damage(amt) -> bool:
	play_hurt()
	spawn_floating_text(amt)
	return false


func spawn_floating_text(amt):
	var t = text.instance()
	t.amount = amt
	add_child(t)
	pass


func play_hurt():
	sprite.play("Hurt")
	yield(sprite, "animation_finished")
	sprite.play("Idle")
