extends Area2D
class_name AttackArea


export(NodePath) var entityPath = ""


func _ready():
	var a = get_node_or_null(entityPath)
	assert(a, "AttackArea has no entity")
	a.attack_area = self
	connect("body_entered", a, "damage_entity")


func disable():
	set_deferred($CollisionShape2D.disabled, false)
func enable():
	set_deferred($CollisionShape2D.disabled, true)
