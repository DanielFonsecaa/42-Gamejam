extends Control

func _unhandled_key_input(event):
	if event.is_action_pressed("close_scene"):
		queue_free()
