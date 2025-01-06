extends RayCast2D

var last_collider

func _process(delta: float) -> void:
	if !is_colliding():
		if last_collider != null:
			resetTransparency(last_collider)
			last_collider = null
	var collider = get_collider()
	if last_collider == collider:
		return
	if collider:
		last_collider = collider
		changeTransparency(collider)

func changeTransparency(collider):
	collider.get_material().set_shader_parameter("transparency_factor", 0.5)

func resetTransparency(collider):
	collider.get_material().set_shader_parameter("transparency_factor", 1)
