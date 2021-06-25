tool
extends Node

"""
Usage:

get_tree().call_group("CameraShake", "add_trauma", 0.3)

"""

func _ready():
	update_configuration_warning() # handle configuration errors
	on_ready()


func _get_configuration_warning():
	if get_parent() is Camera2D:
		return ""
	return "This node requires a Camera2D as a parent to work"


#### Camera Methods ####


export(float, 0, 2, 0.02) var decay_rate = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export(float, 0, 1, 0.02) var max_trauma = 1  # max trauma


onready var noise = OpenSimplexNoise.new()
onready var cam : Camera2D = get_parent()


var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var noise_y = 0


func _process(delta):
	if not cam:
		return
	
	if trauma:
		trauma = max(trauma - decay_rate * delta, 0)
		shake()


func on_ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2


func add_trauma(amount):
	trauma = min(trauma + amount, max_trauma)


func shake():
	var amount = pow(trauma, trauma_power)
	
	noise_y += 1
	cam.rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	cam.offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	cam.offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

