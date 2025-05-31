extends CharacterBody2D  # or Node2D if you're not using physics

@export var speed: float = 50.0

var bed_position: Vector2  # Assigned when spawned
var assigned_bed: Node2D  # Reference to the bed, to release it later

func _process(delta: float) -> void:
	# If a bed has been assigned, move toward it
	if bed_position:
		var direction = (bed_position - position).normalized()
		position += direction * speed * delta

		# If close enough to the bed, consider it "reached"
		if position.distance_to(bed_position) < 5:
			_reach_bed()

func _reach_bed() -> void:
	if assigned_bed:
		assigned_bed.release()
	queue_free()
