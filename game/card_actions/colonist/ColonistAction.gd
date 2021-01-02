extends Node2D

onready var game = get_node("/root/Game")
onready var player = get_node('../')

var houses_on_nodes = []
var node_picked

var instances_created = []

func cleanup():
	for node in houses_on_nodes:
		node.city_card.pickable = false
		#node.city_card.connect("build_picked",self,"city_card_picked")

func _ready():
	game.my_player.create_turn_over_button()
	create_colonist_action_type_pick()

func create_colonist_action_type_pick():
	var new_colonist_action_type_pick = GameData.packed_scenes["ColonistActionTypePick"].instance()
	add_child(new_colonist_action_type_pick)

func collect_coins_picked():
	game.my_player.money += game.my_player.get_node("Colonists").get_child_count()+5
	player.turn_over()
	queue_free()

func place_colonists_picked():
	houses_on_nodes = game.my_player.houses_on_nodes

	for node in houses_on_nodes:
		node.city_card.pickable = true
		node.city_card.connect("build_picked",self,"city_card_picked")
	
	for node in houses_on_nodes:
		if node.water_connections.size() == 0 and node.land_connections.size() != 0:
			if "land" in game.my_player.colonists_added:
				node.city_card.pickable = false
		if node.water_connections.size() != 0 and node.land_connections.size() == 0:
			if "water" in game.my_player.colonists_added:
				node.city_card.pickable = false
		if node.water_connections.size() != 0 and node.land_connections.size() != 0:
			if "water" in game.my_player.colonists_added and "land" in game.my_player.colonists_added:
				node.city_card.pickable = false
	
func city_card_picked(node):
	node_picked = node
	
	if !game.my_player.inventory.has("FoodItem") or !game.my_player.inventory.has("AnvilItem"):
		game.my_player.turn_over()
		queue_free()
	
	game.my_player.delete_turn_over_button()
	create_colonist_type_pick()
	
func create_colonist_type_pick():
	var new_colonist_type_pick = GameData.packed_scenes["ColonistTypePick"].instance()
	add_child(new_colonist_type_pick)
	
func colonist_type_picked(type):
	player.colonists_added.append(type)
	
	for node in houses_on_nodes:
		if node.water_connections.size() == 0 and node.land_connections.size() != 0:
			if "land" in game.my_player.colonists_added:
				node.city_card.pickable = false
		if node.water_connections.size() != 0 and node.land_connections.size() == 0:
			if "water" in game.my_player.colonists_added:
				node.city_card.pickable = false
		if node.water_connections.size() != 0 and node.land_connections.size() != 0:
			if "water" in game.my_player.colonists_added and "land" in game.my_player.colonists_added:
				node.city_card.pickable = false
	
	game.my_player.create_turn_over_button()
	game.my_player.remove_item_from_inv("FoodItem")
	game.my_player.remove_item_from_inv("AnvilItem")
	game.my_player.add_colonist(type,node_picked.id)
	var data = {
		"colonist": [type,node_picked.id]
	}
	Server.rpc_id(1,"UpdateNodeById",game.my_player.my_id,data)
	
	if !game.my_player.inventory.has("FoodItem") or !game.my_player.inventory.has("AnvilItem"):
		game.my_player.turn_over()
		queue_free()

