extends Node

export(int, FLAGS, "A", "B", "C") var e1 = 0
export(int, FLAGS, "A", "B", "C") var e2 = 0


func _ready():
	print("and ", e1 & e2)
	print("or  ", e1 | e2)
	print("xor ", e1 ^ e2)
	
	pass # Replace with function body.

