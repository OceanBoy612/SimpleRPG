extends Area2D
#class_name AttackArea


export(NodePath) var entityPath = ""
export var continous = false


var entity: CombatEntity


func _ready():
	entity = get_node_or_null(entityPath)
	assert(entity, "AttackArea has no entity")
	entity.attack_area = self
	connect("body_entered", entity, "damage_entity")


func _physics_process(delta):
	if continous:
		for body in get_overlapping_bodies():
			entity.damage_entity(body)


func disable():
	set_deferred($CollisionShape2D.disabled, false)
func enable():
	set_deferred($CollisionShape2D.disabled, true)
