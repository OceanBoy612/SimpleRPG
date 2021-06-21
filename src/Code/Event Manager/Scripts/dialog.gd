extends Resource
class_name Dialog
"""
get_next:
	returns: the next string in the dialog or an empty string when the dialog 
			 completes
"""

#signal started
#signal finished


export(Array, String, MULTILINE) var speech

export(int) var current_index = 0
#export(bool) var reset_on_complete = true



func get_next() -> String:
#	assert(current_index < speech.size(), "Dialog ran out of lines")
	print("current index ", current_index)
	if is_finished():
		reset()
	var temp = speech[current_index]
	current_index += 1
	return temp


func reset():
	current_index = 0


func is_started():
	return current_index == 0
func is_finished():
	return current_index == speech.size()
