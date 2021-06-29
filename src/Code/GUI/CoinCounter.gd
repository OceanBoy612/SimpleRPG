extends Control


export(NodePath) var nodePath


func _ready():
	var n : Node2D = get_node_or_null(nodePath)
	if n:
		if n.has_signal("coin_collected"):
			n.connect("coin_collected", self, "on_coin_collected")
		else:
			print("REEEEEEEEEEEEEEEEE")


func on_coin_collected():
	print("a coin has been collected")
	$Label.text = str(int($Label.text) + 1)
