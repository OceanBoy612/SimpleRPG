extends ActionBase
class_name Move


export var amount_to_move = 100
export var speed = 100
export var dir = Vector2(1,0)
var amount_moved = 0


func _on_enable():
	._on_enable()
	amount_moved = 0
	dir = dir.normalized()


func _process(delta):
	get_base().position += dir * delta * speed
	amount_moved += delta * speed
	if amount_moved > amount_to_move:
		emit_signal("completed")
