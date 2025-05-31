extends Panel

@onready var label = $DialogueLabel
@export var typing_speed := 0.05

func _ready():
	await type_text("The room is dark and silent.")
	await get_tree().create_timer(1.0).timeout  # optional pause
	await type_text("Suddenly, you hear footsteps behind you...")

func type_text(text: String) -> void:
	label.text = ""
	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
