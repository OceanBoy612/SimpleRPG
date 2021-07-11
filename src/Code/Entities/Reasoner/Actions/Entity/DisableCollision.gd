extends EntityAction
class_name DisableCollision


export(bool) var enable = false
export(int, LAYERS_2D_PHYSICS) var layer
export(int, LAYERS_2D_PHYSICS) var mask


func _on_enable():
	._on_enable()
	if enable:
		# enable collisions
		entity.set_deferred("collision_layer", entity.collision_layer | layer)
		entity.set_deferred("collision_mask", entity.collision_mask | mask)
	else: 
		# disable collisions
		entity.set_deferred("collision_layer", entity.collision_layer & ~layer)
		entity.set_deferred("collision_mask", entity.collision_mask & ~mask)
	
	emit_signal("completed", OK)
