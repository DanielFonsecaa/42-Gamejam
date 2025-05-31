extends Node2D

func _ready():
	await get_tree().process_frame  # ensures everything is ready first
	var overlay = preload("res://Scenes/text_box/message_girl.tscn").instantiate()
	get_tree().root.add_child(overlay)
	get_tree().paused = true
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	await overlay.closed
	get_tree().paused = false  # ✅ resume the game 
