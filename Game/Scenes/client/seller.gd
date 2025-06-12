extends CharacterBody2D

@onready var sound_thanks = $thanks
@onready var sound_no_money = $no_money
@onready var sound_receive = $receive
@onready var sound_what_ya_buy = $what_ya_buy
@onready var sound_bye = $bye

var sounds = []
var sound_index = 0
var player_in_range = false

func _ready():
	sounds = [
		sound_thanks,
		sound_no_money,
		sound_receive,
		sound_what_ya_buy,
		sound_bye
	]
	$BuyArea.body_entered.connect(_on_body_entered)
	$BuyArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "PlayerBody":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "PlayerBody":
		player_in_range = false

func _input(event):
	if player_in_range and event.is_action_pressed("interact"):
		play_next_sound()

func play_next_sound():
	for s in sounds:
		s.stop()
	sounds[sound_index].play()
	sound_index = (sound_index + 1) % sounds.size()
