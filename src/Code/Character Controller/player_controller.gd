extends Node


export var speed = 400
export var doubleTapTime = 3

onready var kb = get_parent() as KinematicBody2D
onready var AttackArea = get_parent().get_node("Facing/AttackArea")

enum {
	ATTACK,
	MOVE,
	ROLL
}

var state = MOVE
var startAttack = false
var doubleTapTimer = 0
var lastKey = "nothing"
var keyOptions = ["ui_right", "ui_left", "ui_up", "ui_down"]


func _physics_process(delta):
	if not kb:
		print("Character controller requires a KinematicBody2D as a parent")
		return
	
	var axis: Vector2 = _get_input_axis()

	# Check for interaction or attacking
	var acceptPressed = Input.is_action_just_pressed("ui_accept")
	if acceptPressed  and state == MOVE and has_meta("interactable"):
		var inter : Interactable = get_meta("interactable")
		inter.start_interaction()
	elif acceptPressed and state == MOVE:
		state = ATTACK
		startAttack = true
	
	# Check for rolling
	if check_double_press(delta) and state == MOVE:
		state = ROLL
	
	match state:
		MOVE:
			handle_movement(axis)
		ATTACK:
			handle_attacking()
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
	kb.move_and_slide(speed * axis)


func handle_attacking():
	if startAttack:
		AttackArea.run_attack()
		startAttack = false
		# TODO add attacking animation
	elif AttackArea.attacking == false:
		state = MOVE

func handle_rolling():
	print("You rolled")
	state = MOVE

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
