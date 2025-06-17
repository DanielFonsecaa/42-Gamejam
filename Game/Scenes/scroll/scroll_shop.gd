extends Control

signal buy_item
signal no_money

@onready var buy_life_btn = $Panel/Life/Button
@onready var buy_patience_btn = $Panel/Patience/Button
@onready var buy_beds_btn = $Panel/Bed/Button
@onready var buy_speed_btn = $Panel/Speed/Button
@onready var buy_life_price = $Panel/Life/price
@onready var buy_patience_price = $Panel/Patience/price
@onready var buy_beds_price = $Panel/Bed/price
@onready var buy_speed_price = $Panel/Speed/price

var life_price = 15
var bed_price = 15
var patience_price = 15
var speed_price = 30

func _ready():
	buy_life_btn.pressed.connect(_on_BuyLifeButton_pressed)
	buy_patience_btn.pressed.connect(_on_BuyPatienceButton_pressed)
	buy_beds_btn.pressed.connect(_on_BuyBedsButton_pressed)
	buy_speed_btn.pressed.connect(_on_BuySpeedButton_pressed)
	buy_beds_price.text = str(bed_price)
	buy_patience_price.text = str(patience_price)
	buy_life_price.text = str(life_price)
	buy_speed_price.text = str(speed_price)

func _on_BuyLifeButton_pressed():
	print("Life")
	ChestGlobal.buy_life(life_price)
	can_buy(life_price)

func _on_BuyPatienceButton_pressed():
	print("Patience")
	ChestGlobal.buy_patience(patience_price)
	can_buy(life_price)

func _on_BuyBedsButton_pressed():
	print("Bed")
	ChestGlobal.buy_bed(bed_price)
	can_buy(life_price)
	
func _on_BuySpeedButton_pressed():
	print("Speed")
	ChestGlobal.buy_speed(speed_price)
	can_buy(speed_price)

func can_buy(price):
	print(price)
