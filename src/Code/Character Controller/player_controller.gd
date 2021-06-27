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
var doubleTapTimer = 0
var lastKey = "nothing"
var keyOptions = ["ui_right", "ui_left", "ui_up", "ui_down"]

var accept_buffer_time = 0.2
var time_since_accept = 999
var dash_dir = ""


func _process(delta):
	# buffer acceptPressed
#	time_since_accept = 0 if Input.is_action_just_pressed("ui_accept") else time_since_accept + delta
#	var acceptPressed = time_since_accept < accept_buffer_time
	var interact_pressed = Input.is_action_just_pressed("interact")
	# Check for interaction or attacking
	if interact_pressed and state == MOVE and kb.has_meta("interactable"):
		var inter : Interactable = kb.get_meta("interactable")
		inter.start_interaction()

func _physics_process(delta):
	if not kb:
		print("Character controller requires a KinematicBody2D as a parent")
		return
	
	var axis: Vector2 = _get_input_axis()
	
	var attack_pressed = Input.is_action_just_pressed("attack") # leftmousebutton
	if attack_pressed and state == MOVE:
		Weapon.run_attack()
	
	# Check for rolling
	if check_double_press(delta) and state == MOVE:
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
		dash_dir = lastKey
		smartsprit.run_roll(lastKey)
		startRolling = false
	elif smartsprit.rolling == false:
		state = MOVE
		kb.speed_multiplier = 1
	else:
		var dash_axis = Vector2(0, 0)
		if dash_dir == "ui_down":
			dash_axis = Vector2(0, 1)
		elif dash_dir == "ui_up":
			dash_axis = Vector2(0, -1)
		elif dash_dir == "ui_right":
			dash_axis = Vector2(1, 0)
		elif dash_dir == "ui_left":
			dash_axis = Vector2(-1, 0)
#		kb.move_and_slide(speed * dash_axis)
		kb.move_dir = dash_axis
		kb.speed_multiplier = 2

func check_double_press(delta):
	if doubleTapTimer >= doubleTapTime:
		lastKey = "nothing"
		doubleTapTimer = 0
	else:
		doubleTapTimer += delta
	for key in keyOptions:
		var keyPressed = Input.is_action_just_pressed(key) 
		if keyPressed and key == lastKey:
			return true
		elif keyPressed:
			lastKey = key
	return false
