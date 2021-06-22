extends Area2D
class_name Interactable


signal interaction_finished


export var auto_start_interaction := false
export var vanish_on_interaction := false

export(Array, Resource) var interactions


onready var dialogue_balloon: Sprite = $Balloon


var local_map# : LocalMap


func _ready():
	add_to_group("interactable")
#	connect('body_entered', self, '_on_body_entered')
#	connect('body_exited', self, '_on_body_exited')


func initialize(_local_map):
	local_map = _local_map


func focused():
	# gets called when the player is able to interact with this object
	dialogue_balloon.show()
	pass

func unfocused():
	# called when focus is lost
	dialogue_balloon.hide()
	pass


#func _on_body_entered(body: PhysicsBody2D) -> void:
#	if auto_start_interaction:
#		start_interaction()
#	else:
#		dialogue_balloon.show()
#
#
#func _on_body_exited(body: PhysicsBody2D) -> void:
#	dialogue_balloon.hide()
	

func start_interaction() -> void:
	# Pauses the game and play each interaction
	# Interactions that transition to another scene may unpause the game themselves
	# Interactable processes even when the game is paused
	dialogue_balloon.hide()
	get_tree().paused = true
	assert(interactions.size() > 0)
	for interaction in interactions:
		(interaction as Interaction).interact(local_map)
		yield(interaction, "finished")
	emit_signal("interaction_finished", self)
	if vanish_on_interaction:
		queue_free()
	get_tree().paused = false
