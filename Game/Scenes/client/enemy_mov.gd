extends CharacterBody2D  # Or Node2D if no physics
@export var speed: float = 50.0

var bed_position: Vector2
var assigned_bed: Node2D = null
var reached_bed: bool = false
var healed: bool = false
var sickness_id: int = 0
var moving_to_exit: bool = false
var end_pos: Vector2 = Vector2(70, 400)
var player_in_range: bool = false
var sickness_icon: Node = null
var healthy_animation_scene: PackedScene = null

var sickness_to_texture := {
	1: preload("res://Scenes/potion_minigame/assets/potions/fever_potion.png"),
	3: preload("res://Scenes/potion_minigame/assets/potions/simple_antidote.png"),
	2: preload("res://Scenes/potion_minigame/assets/potions/healing_potion.png")
}

func _ready():
	add_to_group("clients")
	$InteractionArea.body_entered.connect(_on_body_entered)
	$InteractionArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "PlayerBody":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "PlayerBody":
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not healed:
		try_heal()
		print("test tryheal")
	if bed_position and not reached_bed:
		var direction = (bed_position - position).normalized()
		position += direction * speed * delta
		if position.distance_to(bed_position) < 5:
			_reach_bed()
	elif reached_bed and moving_to_exit:
		var direction = (end_pos - position).normalized()
		position += direction * speed * delta
		if position.distance_to(end_pos) < 5:
			moving_to_exit = false
func try_heal():
	var current_id = Inventory.potion_id
	if current_id == null:
		print("❌ No potion selected.")
		return
	print("current item")
	print(current_id)
	if sickness_to_texture.has(sickness_id) and Inventory.item_count >= 0:
		if sickness_id == current_id:
			print("✅ Correct potion! Healing client.")
			Inventory.item_count = -1
			Inventory.current_item = null
			Inventory.potion_id = -1
			heal_client()
		else:
			print("❌ Wrong potion.")
	else:
		print("❌ Unknown sickness.")

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

func heal_client() -> void:
	# Remove sickness icon if it exists
	if sickness_icon and sickness_icon.is_inside_tree():
		sickness_icon.queue_free()
		sickness_icon = null
	
	# Add healing animation if we have the scene
	if healthy_animation_scene:
		var heal_anim_instance = healthy_animation_scene.instantiate()
		add_child(heal_anim_instance)
		heal_anim_instance.position = Vector2.ZERO  # Adjust as needed
	
		# Play healing animation
		if heal_anim_instance.has_node("AnimationPlayer"):
			heal_anim_instance.get_node("AnimationPlayer").play("heal")
		elif heal_anim_instance.has_node("AnimatedSprite2D"):
			heal_anim_instance.get_node("AnimatedSprite2D").play("heal")
	
		# Wait for animation duration
		await get_tree().create_timer(3.0).timeout
	
		heal_anim_instance.queue_free()
	
	healed = true
	
	if assigned_bed:
		assigned_bed.release()
	queue_free()
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("get_up")
	
	moving_to_exit = true
