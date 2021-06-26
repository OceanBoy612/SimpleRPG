extends Control
class_name DialogueBox

signal dialogue_ended

onready var dialogue_player = $DialoguePlayer as DialoguePlayer

onready var name_label = $Panel/MC/Rows/Name as Label
onready var text_label = $Panel/MC/Rows/Columns/Text as Label

#onready var button_next = $Panel/MC/Rows/Columns/ButtonNext as Button
#onready var button_finished = $Panel/MC/Rows/Columns/ButtonFinished as Button

onready var portrait = $Portrait as TextureRect

var dialogue_finished = false

func start(dialogue: Dictionary) -> void:
	# Reinitializes the UI and asks the DialoguePlayer to 
	# play the dialogue
#	button_finished.hide()
#	button_next.show()
#	button_next.grab_focus()
#	button_next.text = "Next"
	
	dialogue_player.start(dialogue)
	update_content()
	show()
	dialogue_finished = false


func _on_ButtonNext_pressed() -> void:
	dialogue_player.next()
	update_content()


func _on_DialoguePlayer_finished() -> void:
	dialogue_finished = true
#	button_next.hide()
#	button_finished.grab_focus()
#	button_finished.show()


func _on_ButtonFinished_pressed() -> void:
	emit_signal("dialogue_ended")
	hide()


func update_content() -> void:
	var dialogue_player_name = dialogue_player.title
	name_label.text = DialogueDatabase.get_display_name(dialogue_player_name)
	text_label.text = dialogue_player.text
	portrait.texture = DialogueDatabase.get_texture(
		dialogue_player_name, dialogue_player.expression
	)



func _on_DialogueBox_gui_input(event):
	var cond1 = event is InputEventMouseButton and event.is_pressed()
	var cond2 = event.is_action_pressed("interact") # dones't work
#	print(event, cond1, cond2)
	if cond1 or cond2:
		if dialogue_finished:
			emit_signal("dialogue_ended")
			hide()
		else:
			dialogue_player.next()
			update_content()
