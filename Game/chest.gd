extends Node

var my_money = 0
var fever_price = 20
var injure_price = 10
var poison_price = 30

var chests: Array = []
var chest_queue: Array = []

const itens = {
	"healing_potion": {
		"name": "Healing Potion",
		"id": 2,
		"price": 10,
	},
	"fever_heal_potion": {
		"name": "Fever Healing Potion",
		"id": 1,
		"price": 20,

	},
	"antidote": {
		"name": "Antidote",
		"id": 3,
		"price": 30,
	}
}

func _ready() -> void:
	var found_chest = get_tree().get_nodes_in_group("bau")
	ChestGlobal.chests = found_chest

func pay(price: int) -> void:
	my_money += price
	print(my_money)

func get_available_chest():
	for chest in chests:
		print("Checking chest:", chest.name, "occupied:", chest.is_occupied)
		if not chest.is_occupied:
			return chest
	return null

func queue_client(client):
	chest_queue.append(client)
	process_chest_queue()

func process_chest_queue():
	if chest_queue.size() == 0:
		return
	var chest = get_available_chest()
	if chest and not chest.is_occupied:
		var client = chest_queue.pop_front()
		chest.occupy()
		client.go_to_chest(chest)
