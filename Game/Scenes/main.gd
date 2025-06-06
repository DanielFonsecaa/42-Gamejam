extends Node2D
@onready var minigamestart = $Area2D
@onready var arrow = $AnimatedSprite2D
@onready var arrow2 = $AnimatedSprite2D2
var flag = true
var restarted = false
var item_textures := {
	1: preload("res://Scenes/potion_minigame/assets/potions/fever_potion.png") as Texture2D,
	2: preload("res://Scenes/potion_minigame/assets/potions/simple_antidote.png") as Texture2D,
	3: preload("res://Scenes/potion_minigame/assets/potions/healing_potion.png") as Texture2D,
	4: preload("res://Scenes/potion_minigame/assets/potions/invisble.png") as Texture2D
}


func _ready():
	await get_tree().process_frame  # ensures everything is ready first
	var inventory = preload("res://Scenes/inventory_slot.tscn")
	var inventory_ = inventory.instantiate()
	get_tree().root.add_child(inventory_)
	inventory_.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	inventory_.offset_left = 20
	inventory_.offset_bottom = 100
	if not restarted:
		var overlay = preload("res://Scenes/text_box/message_girl.tscn").instantiate()
		get_tree().root.add_child(overlay)
		get_tree().paused = true
		overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		overlay.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		overlay.size_flags_vertical = Control.SIZE_EXPAND_FILL
		await overlay.closed
		get_tree().paused = false
		await get_tree().create_timer(5.0).timeout
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
		arrow.visible = false
		var minigame_scene = load("res://Scenes/potion_minigame/minigame.tscn")        # Loads the scene
		var minigame = minigame_scene.instantiate()             # Instantiates the scene
		add_child(minigame)                                     # Adds it to the tree (important!)
		var drag_object = minigame.get_node("Panel2/drag_object")
		await get_tree().process_frame
#dra	g_object.connect("gotpotion", Callable(self, "_on_got_potion"))
#awa	it drag_object.gotpotion      
					  

func add():
	if Inventory.potion_id == 1:
		change_inventory_item(1)
	if Inventory.potion_id == 2:
		change_inventory_item(3)
	if Inventory.potion_id == 3:
		change_inventory_item(2)
	if Inventory.potion_id == -1:
		change_inventory_item(4)

func change_inventory_item(index: int):
		if item_textures.has(index):
			var texture = item_textures[index]
			Inventory.add_item(texture)
	
func _process(delta: float) -> void:
	if Inventory.hasitem:
		Inventory.hasitem = false
	add()
	if Inventory.kill:
		await get_tree().create_timer(2.0).timeout
		Inventory.restart = true
		Inventory.kill = false
		restart()

func restart():
	if Inventory.restart:
		var game_over = get_tree().change_scene_to_file("res://Scenes/main_menu/game_over.tscn")
		Inventory.restart = false
		restarted = true
