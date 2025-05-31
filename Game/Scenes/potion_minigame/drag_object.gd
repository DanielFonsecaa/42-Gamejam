extends TextureRect

@export var item_name: String = ""
@export var item_description: String = ""
@onready var panel: Panel = $"../../Panel"

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = [self, 1]
	var preview = TextureRect.new()
	preview.texture = self.texture
	set_drag_preview(preview)
	return data
	
func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered():
	$"../../Panel/item_name".text = item_name
	$"../../Panel/item_description".text = item_description
	panel.visible = true
	panel.follow_mouse = true

func _on_mouse_exited():
	panel.visible = false
	panel.follow_mouse = true
	pass
