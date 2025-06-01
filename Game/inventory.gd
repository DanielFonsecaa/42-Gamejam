extends Node
signal inventory_updated

var hasitem = false
var current_item: Texture2D = null
var item_count: int = 0
var potion_id = null
var minigame_aberto = false

func add_item(item_texture: Texture2D, quantity: int = 1) -> void:
	current_item = item_texture
	item_count += quantity
	inventory_updated.emit()
func add_name_item(item_id: int ) -> void:
	potion_id = item_id
