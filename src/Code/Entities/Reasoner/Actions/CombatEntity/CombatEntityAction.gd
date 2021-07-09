extends ActionBase
class_name CombatEntityAction, "res://Code/Entities/Reasoner/Actions/CombatEntity/combat_entity_action.png"


var entity : CombatEntity


func _on_enable():
	._on_enable()
	entity = get_base() as CombatEntity
	assert(entity)


func _on_disable(): 
	._on_disable()
	if entity:
		entity.move_dir = Vector2()
