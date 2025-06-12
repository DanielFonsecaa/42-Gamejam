extends Control
signal closed

@onready var label = $Panel2/Label
@onready var space_hint = $Panel2/SpaceHint
@export var typing_speed := 0.03

var dialogue_lines := [
	"Ugh... Another day of wasting my precious alchemy 
	on these fools...",
	"Okay. I need to get ready for the day.",
	"(You can use 'W', 'A', 'S' and 'D' to move around!)"
	]

var current_line := 0
var is_typing := false
var skip_typing := false

func _ready():
	$"Bender-mumble-daniel".play()
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_unhandled_input(true)
	space_hint.visible = false
	await show_line()
	
func disable_focus_all_children(node: Node):
	for child in node.get_children():
		if child is Control:
			child.focus_mode = Control.FOCUS_NONE
		disable_focus_all_children(child)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			skip_typing = true  # instantly finish text
		else:
			if current_line < dialogue_lines.size():
				await show_line()
			else:
				emit_signal("closed")
				queue_free()

func show_line() -> void:
	is_typing = true
	space_hint.visible = false
	await type_text(dialogue_lines[current_line])
	current_line += 1
	is_typing = false
	space_hint.visible = true

func type_text(text: String) -> void:
	label.text = ""
	skip_typing = false
	for c in text:
		if skip_typing:
			label.text = text
			return
		label.text += c
		await get_tree().create_timer(typing_speed).timeout
