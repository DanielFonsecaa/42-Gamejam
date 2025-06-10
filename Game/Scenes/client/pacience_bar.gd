extends AnimatedSprite2D

@export var frame_interval: float = 5.0
var elapsed_time: float = 0.0
var current_frame: int = 0
var max_frame: int = 5

var original_position: Vector2
var shake_timer: float = 0.0
var is_shaking: bool = false

var is_reversing: bool = false  # Replacing is_filling
var reverse_speed: float = 0.1  # Faster than normal

func _ready():
	original_position = position

func _process(delta: float) -> void:
	# Handle reverse animation (reset effect)
	if is_reversing:
		elapsed_time += delta
		if elapsed_time >= reverse_speed:
			elapsed_time = 0.0
			current_frame -= 1
			if current_frame >= 0:
				frame = current_frame
			else:
				current_frame = 0
				frame = 0
				is_reversing = false  # Done reversing
		return

	# Normal countdown
	elapsed_time += delta
	if elapsed_time >= frame_interval:
		elapsed_time = 0.0
		current_frame += 1
		if current_frame <= max_frame:
			frame = current_frame
			start_shake()
		elif current_frame == max_frame + 1:
			start_shake()

	# Shake effect
	if is_shaking:
		shake_timer -= delta
		if shake_timer > 0:
			position = original_position + Vector2(
				randf_range(-2, 2),
				randf_range(-2, 2)
			)
		else:
			position = original_position
			is_shaking = false
			if current_frame > max_frame:
				var client = get_parent().get_parent()
				if client and client.has_method("kill"):
					client.kill()

func start_shake():
	is_shaking = true
	shake_timer = 0.3

func reset():
	is_reversing = true
	elapsed_time = 0.0
	is_shaking = false
	shake_timer = 0.0
	position = original_position
