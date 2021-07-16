extends AttackEntity


onready var Spike = preload("res://Code/Entities/Enemies/Scenes/Spike.tscn")


onready var spawn_points = $spawn_points


func _ready():
	$Timer.connect("timeout", self, "kill_spikes")
	
	var first = true
	
	for p in spawn_points.get_children():
		var spike = Spike.instance()
		spike.global_position = p.global_position
		$AttackPattern.add_child(spike)
		if first:
			spike.connect("died", self, "die")
			first = false
	
	pass


func kill_spikes():
	for c in $AttackPattern.get_children():
		if c.has_method("die"):
			c.die()


func die():
	queue_free()
