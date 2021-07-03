extends Entity
class_name WorldItem


export(Resource) var _item
onready var item: Item = _item as Item


#func _ready():
#	if _item == null:
#		_item = Item.new()
#	pass


func on_physics_process(_delta):
	# decay speed
	if speed > 1:
		speed *= 0.9
	else:
		speed = 0
