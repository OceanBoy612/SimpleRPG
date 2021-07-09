extends ActionBase
class_name EntityAction, "res://Code/Entities/Reasoner/Actions/Entity/entity_action.png"


var entity: Entity


func _on_enable():
	._on_enable()
	entity = get_base() as Entity
	assert(entity)


func _on_disable(): 
	._on_disable()
	if entity:
		entity.move_dir = Vector2()
		entity.speed_multiplier = 1.0
