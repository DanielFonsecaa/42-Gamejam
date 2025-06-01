extends Area2D

@export var scene_to_instantiate: PackedScene
var player_nearby = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "PlayerBody":
		player_nearby = true

func _on_body_exited(body):
	if body.name == "PlayerBody":
		player_nearby = false

func _input(event):
	if player_nearby and event.is_action_pressed("interact"):
		if scene_to_instantiate:
			var instance = scene_to_instantiate.instantiate()
			get_tree().current_scene.add_child(instance)
