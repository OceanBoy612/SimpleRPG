extends Area2D
#class_name Attack


export var dot = false
export var base_damage = 1


var source: CombatEntity
var entities = []


func init(s: CombatEntity): # gets called after source is defined
	source = s
	connect("body_entered", self, "on_body_entered")


func _process(delta):
	if dot:
		var bs = get_overlapping_bodies()
		for b in bs:
			source.damage_entity(b, base_damage * delta, 1) # 0 won't work 
	on_process(delta)


func on_process(delta):
	pass


func on_body_entered(body):
	if dot: 
		return 
	if body in entities:
		return
	
	entities.append(body)
	source.damage_entity(body, base_damage)
