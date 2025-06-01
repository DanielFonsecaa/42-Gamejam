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
		# Só abre se não houver minigame aberto
		if not Inventory.minigame_aberto:
			Inventory.minigame_aberto = true
			var minigame = load("res://Scenes/potion_minigame/minigame.tscn").instantiate()
			get_tree().current_scene.add_child(minigame)
			
			# Liga um sinal para saber quando o minigame fecha
			minigame.connect("tree_exited", Callable(self, "_on_minigame_fechado"))

func _on_minigame_fechado():
	Inventory.minigame_aberto = false
