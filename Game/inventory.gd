extends Node
signal inventory_updated

var current_item: Texture2D = null
var item_count: int = 0

func add_item(item_texture: Texture2D, quantity: int = 1) -> void:
	current_item = item_texture
	item_count += quantity
	inventory_updated.emit()
