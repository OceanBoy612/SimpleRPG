extends BaseState
class_name CombatEntityState


var kb: CombatEntity


func enable(_kb: CombatEntity, max_time: float):
	kb = _kb
	.enable(_kb, max_time)


func disable():
	.disable()
	if kb:
		kb.move_dir = Vector2()
