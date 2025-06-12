extends Control

signal buy_item
signal no_money

func _on_BuyLifeButton_pressed():
	var globals = get_node("res://chestGlobal.gd") # or whatever your autoload is named
	if globals.player_can_afford_life():
		globals.buy_life()
		print("buyyyyyyyy")
		emit_signal("buy_item") # Seller thanks
	else:
		emit_signal("no_money") # Seller says no money
# Repeat similar logic for other shop buttons
