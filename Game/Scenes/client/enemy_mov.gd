extends CharacterBody2D  # Or Node2D if no physics

@export var speed: float = 50.0

var bed_position: Vector2
var assigned_bed: Node2D = null
var reached_bed: bool = false
var sickness_name: String = ""

func _process(delta: float) -> void:
	if bed_position and not reached_bed:
		var direction = (bed_position - position).normalized()
		position += direction * speed * delta

		if position.distance_to(bed_position) < 5:
			_reach_bed()
	elif reached_bed:
		# Stay still, animation is playing
		pass

func _reach_bed() -> void:
	var offset = Vector2(0, 30)
	position = bed_position - offset
	# Disable collision with TileMap
	collision_mask &= ~1
	reached_bed = true
	
	# Stop movement:
	velocity = Vector2.ZERO  # If using CharacterBody2D's velocity
	
	# Play the "idle" or "sit" animation:
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("lay_down")  # Replace "idle" with your animation name

	# Optionally release bed on client removal:
	#if assigned_bed:
	#	assigned_bed.release()
	#func enable_collision():
	#collision_mask |= 1  # Add layer 1 back
