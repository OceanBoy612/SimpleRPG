extends Interaction
class_name QuestInteraction


"""
Grants the player a quest that tracks their current stats
and updates when they completed the task

"""

signal completed

export var kill_type : String
export var kill_amt : int

func interact(_local_map) -> void:
	# gives the quest to the player
	print("Interacting with quest")
#	if not target.has_meta("quests"):
#		target.set_meta("quests", [])
#	target.get_meta("quests").append(self)
	target.connect("killed", self, "on_killed")
	yield(target.get_tree().create_timer(0.1),"timeout")
	emit_signal("finished")


func on_killed(what: CombatEntity):
	if what.type == kill_type:
#		print("You have killed a %s!" % what.type)
#		print("num killed: %s" % (target as CombatEntity)._num_killed(what))
		if target._num_killed(what) >= kill_amt:
			print("Yay! you killed them all")
			emit_signal("completed")
	pass
