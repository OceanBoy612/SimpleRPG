tool
extends Resource
class_name LootTable

export(Array, Resource) var loot
export(bool) var _add_loot setget add_loot


func add_loot(v):
	if v == false: return
	
	var a = LootPair.new()
	a.resource_name = "loot %s" % loot.size()
	loot.append(a)
	property_list_changed_notify()


func spawn_loot(source: Node2D):
	for pair in loot:
		if randf() < pair.chance:
			for _i in range(pair.amount):
				var inst = pair.scene.instance()
				inst.global_position = source.global_position
				source.get_parent().call_deferred("add_child", inst)

