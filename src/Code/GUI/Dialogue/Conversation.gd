tool
extends Resource
class_name Conversation

"""
Unimplemented
"""

export(bool) var add_new_line setget add_line
export(Array, Resource) var sentences


func add_line(_v):
	var sen = Sentence.new()
	sen.resource_name = "Sentence"
	sentences.append(sen)
	property_list_changed_notify()


###

#func interact(local_map) -> void:
#	yield(local_map.play_conversation(self), "completed")
#	emit_signal("finished")

