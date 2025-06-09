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
		Inventory.restart = false
		restarted = true
		Properties.lifes = 3
		var game_over = get_tree().change_scene_to_file("res://Scenes/main_menu/game_over.tscn")
		
