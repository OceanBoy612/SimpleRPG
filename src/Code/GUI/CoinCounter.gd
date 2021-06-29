extends Control


export(NodePath) var nodePath
export(String) var item_id


func _ready():
	var n : CombatEntity = get_node_or_null(nodePath)
	if n:
		# need to use _inventory cuz godot is stupid :(
		n._inventory.connect("inventory_changed", self, "inv_changed")
		inv_changed(n._inventory)


func inv_changed(inv: Inventory):
	var amt = inv.get_amount(item_id)
	$TextureRect/Label.text = str(amt)
