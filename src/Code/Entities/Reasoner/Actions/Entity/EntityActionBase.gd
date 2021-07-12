extends ActionBase
class_name EntityActionBase


export(bool) var reset_state = true


func _on_enable():
	._on_enable()
	if "entity" in self:
		self.entity = get_base()
		assert(self.entity)
	


func _on_disable(): 
	._on_disable()
	if "entity" in self:
		if self.entity and reset_state:
			self.entity.move_dir = Vector2()
			self.entity.speed_multiplier = 1.0
