tool
extends Area2D
#class_name InteractableV2


signal interaction_finished


export(bool) var create_multi_conversation setget create_conv
export(Resource) var multi_conv


onready var dialogue_balloon: AnimatedSprite = $Balloon


var local_map# : LocalMap


func _ready():
	add_to_group("interactable")
	if not Engine.editor_hint:
		dialogue_balloon.hide()
	


func initialize(_local_map):
	local_map = _local_map
	multi_conv.init(self)
#	for i in interactions:
#		if i.has_method("init"):
#			i.init(self)


func focused():
	dialogue_balloon.show()


func unfocused():
	dialogue_balloon.hide()


func start_interaction(obj: Entity) -> void:
	# Pauses the game and play each interaction
	# Interactions that transition to another scene may unpause the game themselves
	# Interactable processes even when the game is paused
	dialogue_balloon.hide()
	get_tree().paused = true
#	assert(interactions.size() > 0)
#	for interaction in interactions:
#		(interaction as Interaction).set_target(obj)
#		(interaction as Interaction).interact(local_map)
#		yield(interaction, "finished")
	assert(multi_conv)
	multi_conv.set_target(obj)
	multi_conv.interact(local_map)
	yield(multi_conv, "finished")
	emit_signal("interaction_finished")
#	if vanish_on_interaction:
#		queue_free()
	get_tree().paused = false


### Tool Helpers ###

func create_conv(v):
	if v == false:
		 return
	var a = MultiConversation.new()
	a.resource_name = "MultiConversation"
	multi_conv = a
	property_list_changed_notify()

