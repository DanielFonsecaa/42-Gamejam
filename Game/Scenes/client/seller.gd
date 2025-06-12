extends CharacterBody2D

@onready var sound_thanks = $thanks
@onready var sound_no_money = $no_money
@onready var sound_receive = $receive # (not used in your current logic)
@onready var sound_what_ya_buy = $what_ya_buy
@onready var sound_bye = $bye

var scroll_shop_instance = null

func _ready():
	$BuyArea.body_entered.connect(_on_BuyArea_body_entered)
	$BuyArea.body_exited.connect(_on_BuyArea_body_exited)

func _on_BuyArea_body_entered(body):
	if body.name == "PlayerBody":
		open_scroll_shop()
		play_what_ya_buy()

func _on_BuyArea_body_exited(body):
	if body.name == "PlayerBody":
		close_scroll_shop()
		play_bye()

func open_scroll_shop():
	if scroll_shop_instance == null:
		var ScrollShopScene = preload("res://Scenes/scroll/scroll-shop.tscn")
		scroll_shop_instance = ScrollShopScene.instantiate()
		# Connect purchase signals so the seller can react
		scroll_shop_instance.buy_item.connect(on_buy_item)
		scroll_shop_instance.no_money.connect(on_no_money)
		get_tree().current_scene.add_child(scroll_shop_instance)

func close_scroll_shop():
	if scroll_shop_instance != null:
		scroll_shop_instance.queue_free()
		scroll_shop_instance = null

# --- SOUND FUNCTIONS ---
func play_what_ya_buy():
	stop_all_sounds()
	sound_what_ya_buy.play()

func play_thanks():
	stop_all_sounds()
	sound_thanks.play()

func play_no_money():
	stop_all_sounds()
	sound_no_money.play()

func play_bye():
	stop_all_sounds()
	sound_bye.play()

func stop_all_sounds():
	sound_thanks.stop()
	sound_no_money.stop()
	sound_receive.stop()
	sound_what_ya_buy.stop()
	sound_bye.stop()

# --- SIGNAL CALLBACKS FROM SHOP ---
func on_buy_item():
	play_thanks()

func on_no_money():
	play_no_money()
