#tool
extends Area2D


signal entity_entered(entity)
signal entity_exited(entity)


export var DEBUG = false setget set_DEBUG
export(int, 10, 300) var radius = 150 setget set_radius


onready var kb = get_parent() as Entity


func _ready():
	connect("body_entered", self, "_on_DetectionRadius_body_entered")
	connect("body_exited", self, "_on_DetectionRadius_body_exited")
	


func _on_DetectionRadius_body_entered(body):
	if not body is Entity: # TODO: Should have a collision mask for entities...
		assert(false, "WARNING! your collision masks are set up wrong")
		return
	if body == kb:
		return
	kb.nearby.append(body)
	emit_signal("entity_entered", body)


func _on_DetectionRadius_body_exited(body):
	if not body is Entity: # TODO: Should have a collision mask for entities...
		assert(false, "WARNING! your collision masks are set up wrong")
		return
	if body == kb:
		return
	kb.nearby.erase(body)
	emit_signal("entity_exited", body)


### DEBUG


func _process(delta):
	update()

var default_font: Font = Control.new().get_font("font") # just get the default font
func _draw():
	if not DEBUG:
		return
	
	var str_size: Vector2 = default_font.get_string_size("detection radius")
	draw_arc(Vector2(), radius, 0, 2*PI, 32, Color("#bcad73"), 1.0)
	draw_string(default_font, Vector2(-str_size.x/2, -radius), "detection radius", Color("#bcad73"))


func set_radius(value):
	radius = value
	var col = get_node_or_null("CollisionShape2D")
	if col:
		col.shape.radius = value


func set_DEBUG(value):
	DEBUG = value
	set_process(value)
	update()

