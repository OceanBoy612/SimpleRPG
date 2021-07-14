extends StaticBody2D


signal on
signal off
signal interacted_with


export var disable_interactions: bool = false


onready var dialogue_balloon: AnimatedSprite = $balloon
onready var sprite: AnimatedSprite = $AnimatedSprite


var is_on: bool = false


func _ready():
	dialogue_balloon.hide()
	connect("interacted_with", self, "toggle")


func start_interaction(obj) -> void:
	if not disable_interactions:
		emit_signal("interacted_with", obj)


func toggle(obj):
	if is_on: 
		sprite.play("Wind Off")
		yield(sprite, "animation_finished")
		sprite.play("Off")
		emit_signal("off")
	else:
		sprite.play("Wind On")
		yield(sprite, "animation_finished")
		sprite.play("On")
		emit_signal("on")
	is_on = !is_on

func focused():
	if not disable_interactions:
		dialogue_balloon.show()


func unfocused():
	dialogue_balloon.hide()
