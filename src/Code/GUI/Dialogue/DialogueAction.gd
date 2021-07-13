extends Interaction
#class_name DialogueAction


signal dialogue_loaded(data)


export (String, FILE, "*.json") var dialogue_file_path: String
#export(Array, String, MULTILINE) var speech


func interact(local_map) -> void: # : LocalMap
	var dialogue: Dictionary
	if dialogue_file_path:
		dialogue = load_dialogue(dialogue_file_path)
#	# This needs to be a dict of dicts
#	# {001:{expression:neutral, name:Char1, text:Look I said something},..}
#	else:
#		for s in range(speech.size()):
#			dialogue["%s" % s] = speech[s] #<-- this won't work
#	print(dialogue)
	yield(local_map.play_dialogue(dialogue), "completed")
	emit_signal("finished")


func load_dialogue(file_path) -> Dictionary:
	# Parses a JSON file and returns it as a dictionary
	var file = File.new()
	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue
