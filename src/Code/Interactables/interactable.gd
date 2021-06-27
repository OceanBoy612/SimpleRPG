extends Area2D
class_name Interactable


signal interaction_finished

export var disable = false
export(NodePath) var enable_on_complete # some other interaction
#export var auto_start_interaction := false
export var vanish_on_interaction := false

export(Array, Resource) var interactions

export(Resource) var disable_on_completed # a quest hopefully...
export(Resource) var enable_on_completed


onready var dialogue_balloon: AnimatedSprite = $Balloon


var local_map# : LocalMap


func _ready():
	add_to_group("interactable")
	if disable:
		disable()
	else:
		enable()
	var t = get_node_or_null(enable_on_complete)
	if t:
		t.connect("interaction_finished", self, "enable")
	
	if disable_on_completed:
		disable_on_completed.connect("completed", self, "disable")
	if enable_on_completed:
		enable_on_completed.connect("completed", self, "enable")
	
	
#	connect('body_entered', self, '_on_body_entered')
#	connect('body_exited', self, '_on_body_exited')


func enable():
	print("enabling ", name)
	$CollisionShape2D.set_deferred("disabled", false)


func disable():
	print("disabling ", name)
	$CollisionShape2D.set_deferred("disabled", true)


	


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
	

func start_interaction(obj: Entity) -> void:
	# Pauses the game and play each interaction
	# Interactions that transition to another scene may unpause the game themselves
	# Interactable processes even when the game is paused
	dialogue_balloon.hide()
	get_tree().paused = true
	assert(interactions.size() > 0)
	for interaction in interactions:
		(interaction as Interaction).set_target(obj)
		(interaction as Interaction).interact(local_map)
		yield(interaction, "finished")
	emit_signal("interaction_finished")
	if vanish_on_interaction:
		queue_free()
	get_tree().paused = false
