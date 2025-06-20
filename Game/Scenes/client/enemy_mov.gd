extends CharacterBody2D  # Or Node2D if no physics
@export var speed: float = 50.0
@onready var animated_sprite = $AnimatedSprite2D

signal client_died
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
var payment_animation_scene: PackedScene = null
var chest_position: Vector2
var going_to_chest: bool = false
var reached_chest: bool = false
var chest_node: Node = null
var patience_bar = null
@onready var life1 = $"../Life/heart1"
@onready var life2 = $"../Life/heart2"
@onready var life3 = $"../Life/heart3"
@onready var sound_heal = get_node("heal_sound")
@onready var sound_die = get_node("die_sound")
@onready var sound_pay = get_node("pay_sound")

var sickness_to_texture := {
	1: preload("res://Scenes/potion_minigame/assets/potions/fever_potion.png"),
	3: preload("res://Scenes/potion_minigame/assets/potions/simple_antidote.png"),
	2: preload("res://Scenes/potion_minigame/assets/potions/healing_potion.png")
}

func _ready():
	add_to_group("clients")
	$InteractionArea.body_entered.connect(_on_body_entered)
	$InteractionArea.body_exited.connect(_on_body_exited)
	print("sound_heal: ", sound_heal)
	print("sound_die: ", sound_die)
	print("sound_pay: ", sound_pay)
func _on_body_entered(body):
	if body.name == "PlayerBody":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "PlayerBody":
		player_in_range = false

func go_to_chest(chest):
	chest_node = chest
	chest_node.occupy()
	chest_position = chest.global_position + Vector2(0, -20)  # Offset to stand in front
	going_to_chest = true
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("walk")

func _reach_chest():
	reached_chest = true
	going_to_chest = false
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("idle")
	velocity = Vector2.ZERO

func go_to_chest_with_offset(chest, offset_pos):
	chest_node = chest
	chest_position = offset_pos
	going_to_chest = true
	reached_chest = false
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("walk")

func pay():
	sound_pay.play()
	var price = 0
	match sickness_id:
		1:
			price = ChestGlobal.fever_price
			ChestGlobal.pay(price)
		2:
			price = ChestGlobal.injure_price
			ChestGlobal.pay(price)
		3:
			price = ChestGlobal.poison_price
			ChestGlobal.pay(price)

		# Release the chest
	if chest_node:
		chest_node.release()
		ChestGlobal.process_chest_queue()
		
	if payment_animation_scene:
		var payment_anim_instance = payment_animation_scene.instantiate()
		add_child(payment_anim_instance)
		payment_anim_instance.position = Vector2(-20, -20)  # Adjust as needed
		# 🔽 Set the label text if it exists
		if payment_anim_instance.has_node("PriceLabel"):
			payment_anim_instance.get_node("PriceLabel").text = " $" + str(price)
		await get_tree().create_timer(2.0).timeout
		payment_anim_instance.queue_free()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not healed:
		try_heal()

	if bed_position and not reached_bed:
		var direction = (bed_position - position).normalized()
		position += direction * speed * delta
		if position.distance_to(bed_position) < 5:
			_reach_bed()

	elif going_to_chest and not reached_chest:
		var direction = (chest_position - position).normalized()
		position += direction * speed * delta
		if position.distance_to(chest_position) < 5:
			_reach_chest()

	elif reached_chest and chest_node.is_player_in_range() and Input.is_action_just_pressed("interact"):
	# Only allow payment once
		if not moving_to_exit:
			print("💰 Processing client payment at chest")
			pay()
			# Optional payment animation
			if has_node("AnimationPlayer"):
				$AnimationPlayer.play("pay")
			moving_to_exit = true

	elif moving_to_exit:
		var direction = (end_pos - position).normalized()
		position += direction * speed * delta
		if position.distance_to(end_pos) < 5:
			queue_free()
func try_heal():
	var current_id = Inventory.potion_id
	if current_id == null:
		print("❌ No potion selected.")
		return
	print("current item")
	print(current_id)
	if ChestGlobal.get_available_chest() == null:
		print("❌ No available chest. Wait before healing.")
		return
	if sickness_to_texture.has(sickness_id) and Inventory.item_count >= 0:
		if sickness_id == current_id:
			print("✅ Correct potion! Healing client.")
			Inventory.item_count = -1
			Inventory.current_item = null
			Inventory.potion_id = -1
			heal_client()
		elif sickness_id != current_id and current_id != -1:
			print("💀 Wrong potion! Killing client and player.")
			Inventory.item_count = -1
			Inventory.current_item = null
			Inventory.potion_id = -1
			kill()
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
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("idle")

func heal_client() -> void:
	# Remove sickness icon if it exists
	if sound_heal:
		sound_heal.play()
	else:
		print("sound_heal is null!")
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
	if patience_bar:
		patience_bar.reset()
	# Check if there is an available chest before leaving the bed
	if ChestGlobal.get_available_chest():
		print("✅ Chest available, queuing client")
		ChestGlobal.queue_client(self)
	else:
		print("❌ No chest available, client stays on bed until chest frees")
		# Optionally, keep client waiting on bed until process_chest_queue is called again
	#moving_to_exit = true
func kill() -> void:
	# Stop movement
	sound_die.play()
	velocity = Vector2.ZERO
	animated_sprite.play("die")
	Properties.lifes -= 1
	print("❤️ Lives left:", Properties.lifes)
	match Properties.lifes:
		2:
			life3.play("lost")
		1:
			life2.play("lost")
		0:
			life1.play("lost")
			Inventory.kill = true
	await get_tree().create_timer(2.0).timeout
	if assigned_bed:
		assigned_bed.release()
	queue_free()
