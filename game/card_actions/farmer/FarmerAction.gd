extends Node2D

onready var player = get_parent()

var type_dic = {
	"Mas": "Brick",
	"Far": "Food",
	"Smi": "Anvil",
	"Vin": "Wine",
	"Wea": "Silk"
}
var type

func _ready():
	type = type_dic[player.last_card.substr(0,3)]

	var resources_to_give = []

	for node in player.houses_on_nodes:
		if node.city_card.type == type:
			resources_to_give.append(type)
	
	player.add_to_inventory(resources_to_give)
	player.turn_over()
