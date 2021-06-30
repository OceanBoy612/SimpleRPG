extends Area2D


"""
Attracts items that get within the area
"""

#signal item_picked_up(item)

onready var kb: CombatEntity = get_parent() as CombatEntity

export var pickup_range = 30 setget set_pickup_range
var _pickup_range_squared = pickup_range*pickup_range
var max_len = 80


var items_in_range = []
var to_remove = []


func _on_ItemAttractor_body_entered(body):
	# body should be an item
	body = body as WorldItem
	
	if body:
		if not body in items_in_range:
			items_in_range.append(body)


func _physics_process(delta):
	for i in items_in_range:
		var world_item = i as WorldItem
		attract(world_item)
		if world_item.global_position.distance_squared_to(global_position) < _pickup_range_squared:
			to_remove.append(world_item)
#			kb.emit_signal("coin_collected")
			kb.inventory.add_item(world_item.item)
			print("adding item", items_in_range)
			world_item.queue_free()
	
	for item in to_remove:
		items_in_range.erase(item)
	to_remove.clear()


func attract(item: WorldItem):
	# if it is not moving move directly towards us.
	if item.speed == 0:
		item.move_dir = global_position - item.global_position
	
	var goal_dir = (global_position - item.global_position)#.normalized()
	var new_angle = lerp_angle(item.move_dir.angle(), goal_dir.angle(), 0.3)
	item.move_dir = Vector2(1,0).rotated(new_angle)
	
	var perc = clamp(goal_dir.length() / max_len, 0, 1)
	item.speed = lerp(200, 10, perc)


func set_pickup_range(v):
	pickup_range = v
	_pickup_range_squared = v*v


