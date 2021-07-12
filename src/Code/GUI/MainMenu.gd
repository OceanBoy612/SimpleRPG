extends Control


func _ready():
	show()
	get_tree().paused = true


func _on_Play_pressed():
	get_tree().paused = false
	hide()

