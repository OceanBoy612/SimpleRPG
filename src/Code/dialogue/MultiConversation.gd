tool
extends Interaction
class_name MultiConversation

"""
A multi conversation holds ConvTriggers 
"""

export(bool) var create_trigger setget create_convtrigger
export(Array, Resource) var conv_triggers

var index = 0
var locked = false

func init(_inter):
	for tr in conv_triggers:
		tr.init(self)


func create_convtrigger(v):
	if v == false:
		 return
	var a = ConvTrigger.new()
	a.resource_name = "%s" % conv_triggers.size()
	conv_triggers.append(a)
	property_list_changed_notify()


###

#func finished_triggers():
#	var ct = conv_triggers[index] as ConvTrigger
#	if ct.trigger == "on_previous":
#		pass



func interact(local_map) -> void:
	var dialogue: Dictionary = load_dict()
	yield(local_map.play_dialogue(dialogue), "completed")
	
	emit_signal("finished")
	locked = false


func load_dict() -> Dictionary:
	var d = {}
	var i = 0
	var ct = conv_triggers[index] as ConvTrigger
	var c : Conversation = ct.conversation as Conversation
	
	for sent in c.sentences:
		sent = sent as Sentence
		d[i] = {
			"text" : sent.text, 
			"expression" : sent.expression, 
			"side" : sent.side, 
			"name" : sent.name, 
		}
		i += 1
	
	return d
