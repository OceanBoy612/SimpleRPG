tool
extends Entity
class_name WorldItem


export(Resource) var _item
onready var item: Item = _item as Item
var min_dist = 8

var target: Entity

#func _ready():
#	if _item == null:
#		_item = Item.new()
#	pass

func _ready():
	$DetectionRadius.connect("entity_entered", self, "ent_entered")
	$DetectionRadius.connect("entity_exited", self, "ent_exited")
	$AnimationPlayer.play("bounce")

func ent_exited(_body):
	target = null
	move_dir = Vector2()
#	print("item lost target")

func ent_entered(body):
	# must be the player because of collision mask
	target = body
#	print(target.collision_layer, target.collision_mask)
#	print("item is targetting: ", target.name)


func on_physics_process(_delta):
	# Steer towards the target if it exists
	if $AnimationPlayer.is_playing():
		return
	if not target:
		return
	
	var dist = (target.global_position - global_position)
	if dist.length() < min_dist:
		$Sound.play()
		target.inventory.add_item(item)
		hide()
		set_physics_process(false)
		yield($Sound, "finished")
		queue_free()
	move_dir = move_dir.linear_interpolate(dist.normalized(), 0.2).normalized()
	speed += 7
	speed = clamp(speed, 0, 200)
	


func randomize_move_dir():
	move_dir = Vector2(1, 0).rotated(rand_range(0, 2*PI))
	speed = rand_range(0, 60)
