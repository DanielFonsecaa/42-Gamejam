extends Node2D

@onready var arrow = $AnimatedSprite2D

func _ready():	
	await get_tree().process_frame  # ensures everything is ready first
	var overlay = preload("res://Scenes/text_box/message_girl.tscn").instantiate()
	get_tree().root.add_child(overlay)
	get_tree().paused = true
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay.size_flags_vertical = Control.SIZE_EXPAND_FILL
	await overlay.closed
	get_tree().paused = false
	await get_tree().create_timer(15.0).timeout
	var overlay2 = load("res://Scenes/text_box/message_girl2.tscn").instantiate()
	get_tree().root.add_child(overlay2)
	get_tree().paused = true
	overlay2.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay2.size_flags_vertical = Control.SIZE_EXPAND_FILL
	await overlay2.closed
	get_tree().paused = false
	arrow.visible = true
	
