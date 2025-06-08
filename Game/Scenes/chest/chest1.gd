extends Node2D

var is_occupied: bool = false
var player_in_range: bool = false

func _ready():
	add_to_group("bau")  # Add itself when it's ready
	$ChestInteractionArea.body_entered.connect(_on_body_entered)
	$ChestInteractionArea.body_exited.connect(_on_body_exited)

func occupy():
	is_occupied = true
	print("👉 Chest", name, "occupied")

func release():
	is_occupied = false
	print("👈 Chest", name, "released")

func _on_body_entered(body):
	if body.name == "PlayerBody":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "PlayerBody":
		player_in_range = false

func is_player_in_range() -> bool:
	return player_in_range
