extends Label

@onready var label = $"."
@onready var space_hint = $"../SpaceHint"
@export var typing_speed := 0.03

func _ready():
	await type_text("Ugh... Another day of wasting precious alchemy on these fools...")
	await wait_for_space()

	await type_text("Okay, I must get my stuff ready for the day.")
	await wait_for_space()

	await type_text("(You can use 'W', 'A', 'S' and 'D' to move around.)")
	await wait_for_space()

	space_hint.visible = false

func type_text(text: String) -> void:
	label.text = ""
	space_hint.visible = false

	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout

	space_hint.visible = true
	start_blinking_space_hint()

func wait_for_space() -> void:
	await get_tree().process_frame
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			break
	space_hint.visible = false

# Start the blinking (launches a coroutine)
func start_blinking_space_hint():
	blink_space_hint()

# Must be a top-level function, not nested
func blink_space_hint() -> void:
	# This is an async coroutine by structure, no keyword needed
	call_deferred("_run_blink_loop")  # non-blocking launch

func _run_blink_loop() -> void:
	while space_hint.visible:
		space_hint.modulate.a = 0.0
		await get_tree().create_timer(0.4).timeout
		space_hint.modulate.a = 1.0
		await get_tree().create_timer(0.4).timeout
