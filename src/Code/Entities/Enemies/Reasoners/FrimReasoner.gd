extends Reasoner


var state : ActionBase
var frim : CombatEntity
onready var attack_sound = $AttackSound


func _on_enable():
	._on_enable()
	frim = get_base() as CombatEntity
	frim.detection_radius.connect("entity_entered", self, "alert")
	frim.detection_radius.connect("entity_exited", self, "target_lost")
	choose_next_action()


func target_lost(entity):
	if frim.target == entity:
		frim.target = null


func alert(entity):
	var e: CombatEntity = entity as CombatEntity
	if not e:
		return
	if frim.target == null and frim.is_hostile(e):
		frim.target = e
	pass


func _on_child_action_completed(c):
	choose_next_action()


func choose_next_action():
	if frim.can_attack_target():
		if attack_sound:
			attack_sound.play()
		state = get_node("Attack")
		
		state.enable()
	else:
		state = get_node("Steering")
		state.enable()

