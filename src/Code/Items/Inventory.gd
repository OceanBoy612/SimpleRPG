tool
extends Resource
class_name Inventory

# the inventory doesn't handle inserting items into the inventory panel
#  it simply stores the data, insertions and drops happen elsewhere.
#  this is just an accountant to keep track of where every item is in 
#  the inventory.
#
# As such it maintains a reference to each item that enters the inventory.
#  The only time that this reference is changed here, is when the item is
#  dropped/removed from the inventory. but the logic for this is handled
#  elsewhere. 

signal inventory_changed
signal inventory_reset


export var id = "UNNAMED" setget set_inv_name
export(bool) var add_item setget add_empty_item
export(Array, Resource) var items setget set_item_infos, get_items


#func _init():
#	connect("inventory_changed", self, "_save")
#	print("inv init")


func set_inv_name(v):
	id = v
	resource_name = v
	property_list_changed_notify()


func set_item_infos(new_items: Array):
	# wipes the old inventory and sets it to a new one.
#	print("setting item infos.\t\told: %s\t\tnew: %s" % [items, new_items])
	items = new_items
	emit_signal("inventory_reset", self)
#	emit_signal("inventory_changed", self)


func get_items():
#	print("getting item infos.\t\t%s" % [items])
	return items

### Item based inputs

func add_item(item: Item):
	var ind = get_index(item)
	if ind == -1:
		items.append(item)
	else:
		items[ind].amount += item.amount
	emit_signal("inventory_changed", self)

func remove_item(item: Item):
	assert(has(item), "Attempted to remove an item not within the inventory")
	var ind = get_index(item)
	items.remove(ind)
	emit_signal("inventory_changed", self)


func has(item: Item):
	# returns true if the item is inside the inventory
#	return item in items
	return get_index(item) != -1


func get_index(item: Item):
	# returns the index of a matching item, -1 otherwise
	return get_index_id(item.id)

### Item based inputs

### Name based inputs


func get_index_id(id: String):
	# returns the index of a matching item, -1 otherwise
	if id == "":
		return -1
	for i in range(items.size()):
		var cur: Item = items[i]
		if cur.id == id:
			return i
	return -1


func get_amount(item_id: String) -> int:
	var ind = get_index_id(item_id)
	if ind == -1:
		return 0
	return items[ind].amount


### Name based inputs



#func _save(inv):
#	var save_path = _get_save_path()
#	print("saving inv: %s" % save_path)
#	var save = ResourceSaver.save(save_path, inv)
#	assert(save == 0, "Failed to save the inventory at %s" % save_path)
#
#
#func _load():
#	print("loading inventory: %s" % _get_save_path())
#	var existing_inventory = load(_get_save_path())
#	if existing_inventory:
#		print("successfully loaoded inventory %s" % _get_save_path())
#		set_item_infos(existing_inventory.get_items())
#		return true
#	else:
#		# first time spawn player with some items
#		print("failed to load saved inventory, spawning new item")
#		return false


func _get_save_path():
	return "user://%s.tres" % id



### Tool sccript stuff ###

func add_empty_item(v):
	var item = Item.new()
	item.resource_name = "Item"
	add_item(item)
	property_list_changed_notify()

### Tool sccript stuff ###

















