extends Control

@onready var item_texture = $ItemTexture

func _ready():
	Inventory.inventory_updated.connect(update_slot)
	
	update_slot()
func update_slot():
	item_texture.texture = Inventory.current_item
	item_texture.texture = Inventory.current_item as Texture2D

	
