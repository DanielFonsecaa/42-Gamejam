extends Node2D
@export var spawn_interval: float = 3.0  # seconds between spawns
var timer: float = 0.0

var client_scenes = [
	preload("res://Scenes/client/client_noble.tscn"),
	preload("res://Scenes/client/client_old_man.tscn"),
	preload("res://Scenes/client/client_old_woman.tscn"),
	preload("res://Scenes/client/client_peasant.tscn"),
	preload("res://Scenes/client/client_princes.tscn"),
	preload("res://Scenes/client/client_queen.tscn"),
	preload("res://Scenes/client/client_worker.tscn"),
]

func _process(delta: float) -> void:
	pass
func _ready() -> void:
	call_deferred("_init_beds")
	$Timer.timeout.connect(spawn_client)

func _init_beds():
	var found_beds = get_tree().get_nodes_in_group("bes")
	BedManager.beds = found_beds

func spawn_client() -> void:
	for bed in BedManager.beds:
		if not bed.is_occupied:
			bed.occupy()
			var rand_index = randi() % client_scenes.size()
			var client_instance = client_scenes[rand_index].instantiate()
			client_instance.position = Vector2(70, 400)  # spawn start pos
			print("Assigning bed_position:", bed.global_position)
			client_instance.bed_position = bed.global_position
			client_instance.assigned_bed = bed
			get_tree().current_scene.add_child(client_instance)
			return
	print("❌ No available beds, not spawning new client.")
