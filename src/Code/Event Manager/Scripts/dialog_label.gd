extends Label


signal dialog_started
signal dialog_finished


export(bool) var show_on_started = true
export(bool) var hide_on_finished = true


var current_dialog : Dialog


func set_dialog(dialog : Dialog) -> void:
	current_dialog = dialog


func increment_dialog() -> void:
	if not current_dialog:
		print("no dialogue found, not incrementing the dialogue")
		return
	assert(current_dialog, "Dialog label has no dialog")
#	assert(not current_dialog.is_finished(), "Dialog label cannot increment a completed dialog")
	if current_dialog.is_finished():
		_on_dialog_finished()
		return
	
	
	if current_dialog.is_started():
		_on_dialog_started()
	text = current_dialog.get_next()
	print("text: %s" % [text])


func has_dialog() -> bool:
	return current_dialog != null


## Helpers ##

func _on_dialog_started() -> void:
	if show_on_started:
		print("showing")
		show()
	print("started")
	emit_signal("dialog_started")

func _on_dialog_finished() -> void:
	if hide_on_finished:
		print("hiding")
		hide()
	current_dialog = null
	print("ended")
	emit_signal("dialog_finished")

## Helpers ##

## Debug ##

func _restart_current_dialog() -> void:
	current_dialog.reset()

## Debug ##
