extends Node2D

var is_occupied: bool = false

func _ready():
	add_to_group("bau")  # Add itself when it's ready

func occupy():
	is_occupied = true
	print("👉 Chest", name, "occupied")

func release():
	is_occupied = false
	print("👈 Chest", name, "released")
