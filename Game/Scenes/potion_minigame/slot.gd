extends TextureRect

@export_enum("Circle", "Square") var type = 0
var usd_items = 0

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data[1] == type:
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	#data[0].size = Vector2(10 , 10)
	data[0].get_parent().remove_child(data[0])
	usd_items += 1
	if usd_items == 3:
		get_tree().reload_current_scene()
	#add_child(data[0])
