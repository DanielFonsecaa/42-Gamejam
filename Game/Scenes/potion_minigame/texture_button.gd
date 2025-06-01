extends TextureButton

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Coloque aqui o que você quer que aconteça ao clicar
		$"..".queue_free()
