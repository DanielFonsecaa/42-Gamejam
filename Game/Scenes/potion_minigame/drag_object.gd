extends TextureRect

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = [self, 1]
	var preview = TextureRect.new()
	preview.texture = self.texture
	set_drag_preview(preview)
	return data
