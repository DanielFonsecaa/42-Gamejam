extends Node2D

@onready var arrow = $AnimatedSprite2D

var item_textures := {
	1: preload("res://Scenes/potion_minigame/assets/potions/fever_potion.png") as Texture2D,
	2: preload("res://Scenes/potion_minigame/assets/potions/simple_antidote.png") as Texture2D,
	3: preload("res://Scenes/potion_minigame/assets/potions/healing_potion.png") as Texture2D
}

func _ready():	
	await get_tree().process_frame  # ensures everything is ready first
	var inventory = preload("res://Scenes/inventory_slot.tscn")
	var inventory_ = inventory.instantiate()
	get_tree().root.add_child(inventory_)
	inventory_.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	inventory_.offset_left = 20
	inventory_.offset_bottom = 100
	var overlay = preload("res://Scenes/text_box/message_girl.tscn").instantiate()
	get_tree().root.add_child(overlay)
	get_tree().paused = true
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay.size_flags_vertical = Control.SIZE_EXPAND_FILL
	await overlay.closed
	get_tree().paused = false
	await get_tree().create_timer(13.0).timeout
	var overlay2 = load("res://Scenes/text_box/message_girl2.tscn").instantiate()
	get_tree().root.add_child(overlay2)
	get_tree().paused = true
	overlay2.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay2.size_flags_vertical = Control.SIZE_EXPAND_FILL
	await overlay2.closed
	get_tree().paused = false
	arrow.visible = true
	
func _input(event):
		if event.is_action_pressed("ui_1"):
			change_inventory_item(1)
		elif event.is_action_pressed("ui_2"):
			change_inventory_item(2)
		elif event.is_action_pressed("ui_3"):
			change_inventory_item(3)

func change_inventory_item(index: int):
		if item_textures.has(index):
			var texture = item_textures[index]
			Inventory.add_item(texture)
	
