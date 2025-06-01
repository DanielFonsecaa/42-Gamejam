extends Node2D
@onready var minigamestart = $Area2D
@onready var arrow = $AnimatedSprite2D
var flag = true
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
	var overlay2 = preload("res://Scenes/text_box/message_girl2.tscn").instantiate()
	get_tree().root.add_child(overlay2)
	get_tree().paused = true
	overlay2.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay2.size_flags_vertical = Control.SIZE_EXPAND_FILL
	await overlay2.closed
	get_tree().paused = false
	arrow.visible = true
	await minigamestart.started
	var minigame_scene = load("res://Scenes/potion_minigame/minigame.tscn")        # Loads the scene
	var minigame = minigame_scene.instantiate()             # Instantiates the scene
	add_child(minigame)                                     # Adds it to the tree (important!)
	var drag_object = minigame.get_node("Panel2/drag_object")
	await get_tree().process_frame
	#drag_object.connect("gotpotion", Callable(self, "_on_got_potion"))
	#await drag_object.gotpotion      
					  
func _on_got_potion():
	var overlay3 = preload("res://Scenes/text_box/message_girl3.tscn").instantiate()
	get_tree().root.add_child(overlay3)
	get_tree().paused = true
	overlay3.set_process_unhandled_input(true)
	overlay3.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay3.size_flags_vertical = Control.SIZE_EXPAND_FILL
	await overlay3.closed
	get_tree().paused = false
	
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
	
func _process(delta: float) -> void:
	if Inventory.hasitem and flag:
		_on_got_potion()
		Inventory.hasitem = false
		flag = false
