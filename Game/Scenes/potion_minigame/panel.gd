extends Panel

var follow_mouse := false

func _process(delta):
	if follow_mouse:
		# Ajuste o offset conforme necessário para não cobrir o cursor
		var mouse_pos = get_viewport().get_mouse_position()
		position = mouse_pos + Vector2(16, 16)
