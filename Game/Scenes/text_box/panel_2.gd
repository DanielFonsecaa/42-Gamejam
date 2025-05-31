extends Panel

@onready var dialogue_label = $DialogueLabel
@export var typing_speed := 0.04

var dialogue_lines = [
	"Welcome to the ancient ruins.",
	"Legends say a treasure lies beneath.",
	"But beware — it's guarded by ancient spirits."
]

var current_line = 0
var typing = false
var skip_typing = false

func _ready():
	show_line()

func show_line():
	if current_line < dialogue_lines.size():
		typing = true
		type_text(dialogue_lines[current_line])
		current_line += 1
	else:
		# Dialogue ended
		hide()
		# You can emit a signal or resume player control here

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if typing:
			skip_typing = true
		else:
			show_line()

func type_text(text: String) -> void:
	dialogue_label.text = ""
	skip_typing = false
	await get_tree().process_frame  # Avoids potential race condition

	for i in text.length():
		if skip_typing:
			dialogue_label.text = text
			break
		dialogue_label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout

	typing = false
