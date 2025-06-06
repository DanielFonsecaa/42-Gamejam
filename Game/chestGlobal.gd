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
func _ready():
	chests = get_tree().get_nodes_in_group("bau")
	print("Found chests:", chests.size())

func pay(price: int) -> void:
	my_money += price
	print(my_money)

func get_available_chest():
	for chest in chests:
		print("Checking chest:", chest.name, "occupied:", chest.is_occupied)
		if not chest.is_occupied:
			return chest
	return null

func queue_client(enemy):
	print("Queueing client:", enemy.name)
	chest_queue.append(enemy)
	process_chest_queue()

func process_chest_queue():
	print("Processing chest queue")
	if chest_queue.size() == 0:
		print("Chest queue is empty")
		return

	var available_chest = get_available_chest()
	if available_chest == null:
		print("No chest available, clients wait")
		return

	var enemy = chest_queue.pop_front()
	print("Assigning enemy", enemy.name, "to chest", available_chest.name)
	available_chest.occupy()
	enemy.go_to_chest(available_chest)
