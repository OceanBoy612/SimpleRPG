extends Node2D


export(Array, Resource) var dialogs


onready var dialog_label = $Label


var curr_index = 0


func _ready():
	dialog_label.set_dialog(dialogs[curr_index])
	curr_index += 1
	dialog_label.connect("dialog_finished", self, "on_dialogue_finished")


func _on_Area2D_mouse_entered():
	dialog_label.increment_dialog()


func on_dialogue_finished():
#	print("curr index: ", curr_index)
	if curr_index < dialogs.size():
		dialog_label.set_dialog(dialogs[curr_index])
		curr_index += 1
		dialog_label.increment_dialog()
