extends EntityActionBase
class_name EntityAction, "res://Code/Entities/Reasoner/Actions/Entity/entity_action.png"
#
#
#export(bool) var reset_state = true
#
#
var entity: Entity
#
#
#func _on_enable():
#	._on_enable()
#	entity = get_base() as Entity
#
#	assert(entity)
#
#
#func _on_disable(): 
#	._on_disable()
#
#	#TODO: Merge Entity Action and CombatEntityAction using self.
##	if self.hello:
##		print("pissza")
#	if entity and reset_state:
#		entity.move_dir = Vector2()
#		entity.speed_multiplier = 1.0
