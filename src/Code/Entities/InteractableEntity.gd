extends Entity
class_name InteractableEntity


"""
An entity that you can walk up to and press e to "interact" in some way
"""

signal interacted_with(who)


export var disable_interactions: bool = false


onready var dialogue_balloon: AnimatedSprite = $balloon as AnimatedSprite


func on_ready():
	.on_ready()
	dialogue_balloon.hide()


func start_interaction(obj: Entity) -> void:
	if not disable_interactions:
		if DEBUG: ("%s interacting with %s!" % [obj.name, name])
		emit_signal("interacted_with", obj)
	pass


func focused():
	if not disable_interactions:
		dialogue_balloon.show()


func unfocused():
	dialogue_balloon.hide()
