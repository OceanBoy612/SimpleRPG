extends Control


export(NodePath) var combatEntityPath
export(float) var anim_time = 0.5


var low_offset = 0.29 # unique for the sprites used in the progress bar
var high_offset = 0.88


func _ready():
	var combat_entity : CombatEntity = get_node_or_null(combatEntityPath)
	if combat_entity:
		combat_entity.connect("health_changed", self, "on_health_changed")
#		combat_entity.connect("mana_changed", self, "on_mana_changed")
	
	

func on_health_changed(new_health, max_health) -> void:
	var new_perc = _tween_bar($health_bg/bar, new_health, max_health)
	
	var is_damaged = new_perc < $health_bg/bar.value
	if is_damaged:
		get_tree().call_group("CameraShake", "add_trauma", 0.23)
		$AnimationPlayer.play("shake")


func on_mana_changed(new_mana, max_mana) -> void:
	var new_perc = _tween_bar($mana_bg/bar, new_mana, max_mana)


func _tween_bar(bar: TextureProgress, new_health: float, max_health: float) -> float:
	var new_perc = lerp(low_offset, high_offset, new_health / max_health)
	
	$Tween.interpolate_property(bar, "value", 
			bar.value, new_perc, anim_time, 
			Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	
	return new_perc
