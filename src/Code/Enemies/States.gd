#tool
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

old way:
#	# yield until the state completes
#	yield(state, "completed")
#	# stop the state
#	state.disable()
#	# repeat
#	_start_random_state()

"""

onready var kb = get_parent() as KinematicBody2D
var state: State
#onready var spawn_pos : Vector2 = kb.global_position


func _ready():
	kb.set_meta("spawn_point", kb.global_position)
	
	if not Engine.editor_hint:
#		_start_random_state()
		state = $Wander
		_start_state()







### Callbacks ###

func _on_DetectionRadius_entity_entered(entity):
	# if that entity is hostile and we are wandering
	#  set it as the target and complete the current 
	#  action and attack
	if state.name != "Wander":
		return
	
	# check that the entity is hostile
	if not _is_entity_hostile(entity):
		return
	
	# stop wandering
	state.disconnect("completed", self, "_state_completed")
	state.disable()
	
	# go into the alert state.
	
	# go into the attack state
	state = get_node_or_null("Attack")
	assert(state, "No attack state")
	_start_state()


func _state_completed():
	state.disable()
	_start_random_state()

### Callbacks ###

### Helpers ###


func _start_random_state():
	state = get_child(randi() % get_child_count()) as State
	_start_state()


func _start_state():
	if not state.is_connected("completed", self, "_state_completed"):
		state.connect("completed", self, "_state_completed")
	else:
		print("Warn: Repeating the %s state" % state.name)
	state.enable(kb, 112.5)
	print("started: ", state.name)


func _is_entity_hostile(entity) -> bool:
	return true

### Helpers ###














