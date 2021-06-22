extends Node2D
class_name UtilityStateMachine


"""
This may be a mistake. It might be better to have states which only occur on a
 single frame, that way interrupts from other frames can happen more easily.
 
 I am not sure how interrupts would work in this case. 

 perhaps... if an event that can cause an interrupt happens. We do 
 state.emit_signal(completed) to force it to finish early. Then we just choose 
 another state normally. This would require an interrupt to guarrantee that
 the reaction state is chosen afterwards. (eg. damage/knockback)


"""

onready var kb = get_parent() as KinematicBody2D
var state: State
#onready var spawn_pos : Vector2 = kb.global_position


func _ready():
	kb.set_meta("spawn_point", kb.global_position)
	loop()
	pass


func loop():
	# choose a state
	state = get_child(randi() % get_child_count()) as State
#	state = get_child(0)
	# start the state
	state.enable(kb, 2.5)
	print("started: ", state.name)
	# yield until the state completes
	yield(state, "completed")
	# stop the state
	state.disable()
	# repeat
	loop()

















