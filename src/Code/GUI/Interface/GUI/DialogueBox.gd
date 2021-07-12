extends Control
class_name DialogueBox

signal dialogue_ended

export var chars_per_second = 21

onready var dialogue_player = $DialoguePlayer as DialoguePlayer

onready var name_label = $Panel/MC/Rows/Name as Label
onready var text_label = $Panel/MC/Rows/Columns/Text as Label
onready var click_next = $Panel/MC/Rows/Columns/Text/ClickNext as Control

#onready var button_next = $Panel/MC/Rows/Columns/ButtonNext as Button
#onready var button_finished = $Panel/MC/Rows/Columns/ButtonFinished as Button

onready var portrait_l = $Panel/MC/Rows/Columns/PortraitLeft as TextureRect
onready var portrait_r = $Panel/MC/Rows/Columns/PortraitRight as TextureRect

onready var tween = $Tween as Tween

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
	start_type_write()


func _on_DialoguePlayer_finished() -> void:
	dialogue_finished = true
#	button_next.hide()
#	button_finished.grab_focus()
#	button_finished.show()


func update_content() -> void:
	var dialogue_player_name = dialogue_player.title
	name_label.text = DialogueDatabase.get_display_name(dialogue_player_name)
	text_label.text = dialogue_player.text
	var tex = DialogueDatabase.get_texture(
		dialogue_player_name, dialogue_player.expression
	)
	portrait_l.texture = tex
	portrait_r.texture = tex
	print(dialogue_player.side, dialogue_player.side == "left", dialogue_player.side == "right")
	if dialogue_player.side == "left":
		portrait_l.show()
		portrait_r.hide()
	elif dialogue_player.side == "right":
		portrait_r.show()
		portrait_l.hide()
	else:
		portrait_r.hide()
		portrait_l.hide()
		


func start_type_write():
	var duration = text_label.text.length() / chars_per_second
	tween.interpolate_property(text_label, "percent_visible",
			0, 1, duration, Tween.TRANS_LINEAR)
	tween.interpolate_property(click_next, "visible",
			false, true, 0, Tween.TRANS_LINEAR, Tween.EASE_IN, duration)
	tween.start()
	click_next.visible = false



func _on_DialogueBox_gui_input(event):
	var cond1 = event is InputEventMouseButton and event.is_pressed()
	var cond2 = event.is_action_pressed("interact") # doesn't work
#	print(event, cond1, cond2)
	if cond1 or cond2:
		if tween.is_active():
			tween.seek(tween.get_runtime()) # finish the tween
			click_next.visible = true
		elif dialogue_finished:
			emit_signal("dialogue_ended")
			hide()
		else:
			dialogue_player.next()
			update_content()
			start_type_write()
