extends Node2D


"""
Goes through all test scenes and asserts that their output matches
"""

var curr_dir = "res://Code/Entities/Reasoner/~testing_reasoner/"

func _ready():
	var test_scenes = get_test_scenes(curr_dir + "Low Level Tests/")
	for scene in test_scenes:
		var inst = scene.instance()
		add_child(inst)
		# for for nothing to move
	print(test_scenes)










func get_test_scenes(path):
	var file_names = dir_contents(path, ".tscn")
	var scenes = []
	for file in file_names:
		var loaded = load(path + file)
		scenes.append(loaded)
	return scenes


func dir_contents(path, ext=""):
	var dir = Directory.new()
	var file_names = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(ext):
#				print("Found file: " + file_name)
				file_names.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return file_names
