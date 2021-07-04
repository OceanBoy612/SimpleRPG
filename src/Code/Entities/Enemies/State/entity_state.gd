extends BaseState
class_name EntityState


var kb: Entity


func enable(_kb: Entity, max_time: float):
	kb = _kb
	.enable(_kb, max_time)


func disable():
	.disable()
	if kb:
		kb.move_dir = Vector2()
