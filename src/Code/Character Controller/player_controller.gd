extends Node


export var speed = 400
export var doubleTapTime = 3

onready var kb = get_parent() as CombatEntity
onready var Weapon = kb.get_node("Facing/Weapon")
onready var smartsprit = kb.get_node("SmartSprite")

enum {
	MOVE,
	ROLL
}

var state = MOVE
#var startAttack = false
var startRolling = false
# Used for rolling
#var doubleTapTimer = 0
var lastKey = "nothing"
#var keyOptions = ["ui_right", "ui_left", "ui_up", "ui_down"]

var accept_buffer_time = 0.2
var time_since_accept = 999
var dash_dir = ""
var dash_axis


func _input(event):
	if event.is_action_pressed("drink_potion"):
		if kb.health != kb.max_health:
			var amt = kb.inventory.get_amount("Health Potion")
			if amt > 0:
				kb.heal(5)
				kb.inventory.change_amount("Health Potion", -1)
	if event.is_action_pressed("interact"):
		if state == MOVE and kb.has_meta("interactable"):
			var inter = kb.get_meta("interactable")
			if is_instance_valid(inter) and inter.has_method("start_interaction"):
				inter.start_interaction(kb)


#func _process(delta):
#	# buffer acceptPressed
##	time_since_accept = 0 if Input.is_action_just_pressed("ui_accept") else time_since_accept + delta
##	var acceptPressed = time_since_accept < accept_buffer_time
#	var interact_pressed = Input.is_action_just_pressed("interact")
#	# Check for interaction or attacking
#	if interact_pressed and state == MOVE and kb.has_meta("interactable"):
##		var inter : Interactable = kb.get_meta("interactable")
#		var inter : InteractableV2 = kb.get_meta("interactable")
#		if is_instance_valid(inter):
#			inter.start_interaction(kb)

func _physics_process(delta):
	if not kb:
		print("Character controller requires a KinematicBody2D as a parent")
		return
	
	var axis: Vector2 = _get_input_axis()
	
	var attack_pressed = Input.is_action_just_pressed("attack") # leftmousebutton
	if attack_pressed and state == MOVE:
		Weapon.run_attack()
	
	# Check for rolling
	var roll_pressed = Input.is_action_just_pressed("dash")
	if roll_pressed and state == MOVE and axis != Vector2.ZERO:
		dash_dir = lastKey
		dash_axis = axis
		if axis.x > 0:
			dash_dir = "ui_right"
		elif axis.x < 0:
			dash_dir = "ui_left"
		elif axis.y > 0:
			dash_dir = "ui_down"
		elif axis.y < 0:
			dash_dir = "ui_up"
		state = ROLL

		startRolling = true
	match state:
		MOVE:
			handle_movement(axis)
		ROLL:
			handle_rolling()
	

func _get_input_axis() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)


func handle_movement(axis):
	if axis != Vector2.ZERO:
		kb.set_meta("rotation", axis.angle())	
	kb.set_meta("direction", speed * axis)
#	kb.move_and_slide(speed * axis)
	kb.move_dir = axis


#func handle_attacking():
#	kb.move_dir = Vector2() # stop moveing when attacking
#	if startAttack:
#
#		startAttack = false
#	elif Weapon.attacking == false:
#		state = MOVE

func handle_rolling():
	if startRolling:
		smartsprit.run_roll(dash_dir)
		startRolling = false
	elif smartsprit.rolling == false:
		state = MOVE
		kb.speed_multiplier = 1
	else:
#		kb.move_and_slide(speed * dash_axis)
		kb.move_dir = dash_axis
		kb.speed_multiplier = 2

#func check_double_press(delta):
#	if doubleTapTimer >= doubleTapTime:
#		lastKey = "nothing"
#		doubleTapTimer = 0
#	else:
#		doubleTapTimer += delta
#	for key in keyOptions:
#		var keyPressed = Input.is_action_just_pressed(key) 
#		if keyPressed and key == lastKey:
#			return true
#		elif keyPressed:
#			lastKey = key
#	return false
