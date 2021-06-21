extends Area2D
class_name Interactable


signal interaction_finished


export var auto_start_interaction := false
export var vanish_on_interaction := false

export(Array) var interactions


onready var dialogue_balloon: Sprite = $Balloon


func _ready():
	connect('body_entered', self, '_on_body_entered')
	connect('body_exited', self, '_on_body_exited')


func _on_body_entered(body: PhysicsBody2D) -> void:
	if auto_start_interaction:
		start_interaction()
	else:
		dialogue_balloon.show()


func _on_body_exited(body: PhysicsBody2D) -> void:
	dialogue_balloon.hide()
	

func start_interaction() -> void:
	# Pauses the game and play each action under the $Actions node
	# Actions that transition to another scene may unpause the game themselves
	# Interactable processes even when the game is paused
	dialogue_balloon.hide()
	get_tree().paused = true
	var actions = $Actions.get_children()
	assert(actions != []) # An Interactable should have some interaction
	for action in actions:
		(action as Interaction).interact()
		yield(action, "finished")
	emit_signal("interaction_finished", self)
	if vanish_on_interaction:
		queue_free()
	get_tree().paused = false
