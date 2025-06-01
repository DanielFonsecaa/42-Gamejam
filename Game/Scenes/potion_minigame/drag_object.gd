extends TextureRect
signal gotpotion
@export var item_id: String = ""
@export var item_name: String = ""
@export var item_description: String = ""
@export var is_potion: bool = false
@export var draggable: bool = false
@export var tooltip: bool = true
@onready var panel: Panel = $"../../Panel"

func find_slot_node():
	var current = get_parent()
	while current:
		# Troque "slot.gd" pelo nome do script, se necessário
		if current.has_method("_drop_data"):
			return current
		current = current.get_parent()
	return null

func _get_drag_data(at_position: Vector2) -> Variant:
	if draggable:
		var data = [self, 1, item_id]
		var preview = TextureRect.new()
		preview.z_index = 99
		preview.texture = self.texture
		set_drag_preview(preview)
		return data
	else:
		return null
	
func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	connect("gui_input", Callable(self, "_on_gui_input"))

func _on_mouse_entered():
	if tooltip:
		$"../../Panel/item_name".text = item_name
		$"../../Panel/item_description".text = item_description
		panel.visible = true
		panel.follow_mouse = true

func _on_mouse_exited():
	if tooltip:
		panel.visible = false
		panel.follow_mouse = true
		pass

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if draggable:
			var slot = get_node("../../TextureRect")
			if slot:
				var data = [self, 1, item_id]
				slot._drop_data(Vector2.ZERO, data)
		elif is_potion:
			claim_potion()

func claim_potion():
	# Coloque aqui a ação desejada ao usar a poção
	# TODO: Add to inventory
	print("Got potion!")
	emit_signal("gotpotion")
	Inventory.hasitem = true
	$"../..".queue_free()
