tool
extends Resource
class_name ConvTrigger


signal conversation_triggered


export(String, "on-ready", "on-previous", "on-quest") var trigger = "on-ready"

export(bool) var create_conversation setget create_conversation
export(bool) var create_quest setget create_quest
export(Resource) var conversation = null
export(Resource) var quest = null

func create_quest(v):
	if v == false:
		 return
	var a = QuestInteraction.new()
	a.resource_name = "Quest"
	quest = a
	property_list_changed_notify()


func create_conversation(v):
	var a = Conversation.new()
	a.resource_name = "Conversation"
	conversation = a
	property_list_changed_notify()



func init(mc):#: MultiConversation):
	match trigger:
		"on-ready":
			pass # do nothing
			mc.connect("finished", self, "trigger_ready", [mc])
		"on-previous":
			pass # connect to previous finished method
			mc.connect("finished", self, "trigger_prev", [mc])
		"on-quest":
			assert(quest, "no quest found, on a on-quest conversation trigger")
			quest = quest as QuestInteraction
			quest.connect("completed", self, "trigger_quest", [mc, quest])
			pass # connect to the quests completed method


func trigger(mc):#: MultiConversation):
	var self_i = mc.conv_triggers.find(self)
	assert(self_i - 1 == mc.index, "conversation triggered in the improper place")
	mc.index += 1

func trigger_ready(mc):
	give_quest(mc)
	mc.disconnect("finished", self, "trigger_ready")

func trigger_prev(mc):
	trigger(mc)
	give_quest(mc)
	mc.disconnect("finished", self, "trigger_prev")
	
func trigger_quest(mc, quest):
	trigger(mc)
	quest.disconnect("completed", self, "trigger_quest")

	
func give_quest(mc):
	# give quest if it has one
	quest = quest as QuestInteraction
	if trigger != "on-quest" and quest != null:
		# give the quest...how
		quest.set_target(mc.target)
		quest.interact(null)
#		yield(quest, "finished")
		print("success")
		pass
