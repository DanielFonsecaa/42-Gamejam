extends Area2D
signal started
var player_nearby = false
var first_time = false

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
		if first_time:
			var minigame = load("res://Scenes/potion_minigame/minigame.tscn").instantiate()
			get_tree().current_scene.add_child(minigame)
			
		emit_signal("started")
		first_time = true
