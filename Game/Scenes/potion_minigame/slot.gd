extends TextureRect

@export_enum("Circle", "Square") var type = 0
var usd_items = 0

var dropped_items := []
var initial_items_data := []

# Lista de receitas possíveis
const RECIPES = {
	"healing_potion": ["healing_herb", "sunny_flower"],
	"fever_heal_potion": ["luminous_mushroom", "sunny_flower"],
	"antidote": ["healing_herb", "sunny_flower", "luminous_mushroom"]
}

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

	#add_child(data[0])
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var dragged_object = data[0]
	var item_id = data[2] # Pega o item_id passado pelo drag_object
	dropped_items.append(item_id)
	dragged_object.queue_free() # Remove o item da interface
	_check_recipe() # Verifica se uma receita foi completada

func _check_recipe():
	for recipe_name in RECIPES.keys():
		var ingredients = RECIPES[recipe_name]
		if dropped_items.size() == ingredients.size():
			var temp_ingredients = dropped_items.duplicate()
			var is_match = true
			for item in ingredients:
				if temp_ingredients.has(item):
					temp_ingredients.erase(item)
				else:
					is_match = false
					break
			if is_match:
				_on_recipe_completed(recipe_name)
				return
	# Se chegou aqui, não houve match: resetar os items	reset_items()


func _on_recipe_completed(recipe_name):
	print("Receita criada: %s" % recipe_name)
	# Aqui pode adicionar lógica para mostrar feedback, criar o item, etc.
	# dropped_items.clear()
