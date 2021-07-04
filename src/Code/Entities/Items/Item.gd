tool
extends Resource
class_name Item

export(String) var id setget set_id
export(int) var amount = 1 setget set_amount

func set_id(v):
	id = v
	update()

func set_amount(v):
#		if v <= 0: # when the item has 0, die?
	amount = v
	update()

func update():
	resource_name = "%s x%s" % [id, amount]
	property_list_changed_notify()
