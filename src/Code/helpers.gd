class_name Helpers

static func read_json_file(json_file_path : String) -> Dictionary:
	var file = File.new()
	file.open(json_file_path, File.READ)
	var json = JSON.parse(file.get_as_text()).result
	file.close()
	return json

### Python lambda functions ###

"""
Usage:
Helpers.reduce([1,2,3], funcref(Helpers, "larger"))
"""

static func reduce(input: Array, function: FuncRef, base=null):
	var accumulator = base
	var index = 0
	if not base and input.size() > 0:
		accumulator = input[0]
		index = 1
	while index < input.size():
		accumulator = function.call_func(accumulator, input[index])
		index += 1
	return accumulator

static func map(input: Array, function: FuncRef) -> Array:
	var result = []
	result.resize(input.size())
	for i in range(input.size()):
		result[i] = function.call_func(input[i])
	return result

static func filter(input: Array, function: FuncRef) -> Array:
	var result = []
	for ele in input:
		if function.call_func(ele):
			result.append(ele)
	return result

### Python lambda functions ###

### Helpers for the Python Lambda functions ###

static func sum(a, b): return a + b
static func diff(a, b): return a - b
static func larger(n1, n2): return n1 if n1 > n2 else n2
static func smaller(n1, n2): return n1 if n1 < n2 else n2

### Helpers for the Python Lambda functions ###

### Input Helpers ###

static func get_input_axis() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

### Input Helpers ###
