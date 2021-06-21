extends Node
class_name LocalMap

signal dialogue_finished


onready var dialogue_box = $Interface/DialogueBox


func _ready() -> void:
	assert(dialogue_box)
	for action in get_tree().get_nodes_in_group("interaction"):
		(action as Interaction).initialize(self)


func play_dialogue(data):
	dialogue_box.start(data)
	yield(dialogue_box, "dialogue_ended")
