extends Node

var beds: Array = []

func get_available_bed():
	for bed in beds:
		if not bed.is_occupied:
			return bed
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
