extends Control


func _ready():
	show()
	get_tree().paused = true


func _on_Play_pressed():
	get_tree().paused = false
	hide()


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Credits_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	# safe way to request the operating system to quit the game
	# these two seem to do the same thing...
	# first one might be a windows only thing, so using the second one. 
#	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	get_tree().quit()

