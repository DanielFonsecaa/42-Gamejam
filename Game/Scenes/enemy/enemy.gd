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
var sicknesses = {
	1:preload("res://Scenes/sickness/fever.tscn"),
	3:preload("res://Scenes/sickness/poison.tscn"),
	2:preload("res://Scenes/sickness/injure.tscn"),
}
var sickness_icon: Node = null
var healthy_animation = preload("res://Scenes/sickness/healthy.tscn")
var sickness_id = null
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
			client_instance.position = Vector2(70, 400)
			client_instance.bed_position = bed.global_position
			client_instance.assigned_bed = bed

			# Add client first
			get_tree().current_scene.add_child(client_instance)

			# Add sickness icon as a child of client
			var keys = sicknesses.keys()
			var rand_key = keys[randi() % keys.size()]
			var sickness_icon_instance = sicknesses[rand_key].instantiate()
			client_instance.sickness_id = rand_key
			client_instance.sickness_icon = sickness_icon_instance
			# Position relative to client origin (local position)
			sickness_icon_instance.position = Vector2(-55, -20)  # adjust offset as you want
			client_instance.add_child(sickness_icon_instance)
			client_instance.sickness_icon = sickness_icon_instance
			client_instance.healthy_animation_scene = healthy_animation

			return
