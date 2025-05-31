extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D
func _physics_process(delta: float) -> void:
	# Add the gravity.
	# if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	var vertical := Input.get_axis("up", "down")
	if vertical:
		velocity.y = vertical * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

# left -1 -- rigth 1
	var horizontal := Input.get_axis("left", "right")
	if horizontal == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")
	if horizontal > 0:
		animated_sprite.flip_h = false
	elif horizontal < 0:
		animated_sprite.flip_h = true
	if horizontal:
		velocity.x = horizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
