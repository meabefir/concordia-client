extends Node2D

onready var colonists_node = get_node("../../Colonists")
onready var game = get_node("/root/Game")
onready var player = get_node('../../')

var house_costs = GameData.house_costs

func kill():
	queue_free()

func _ready():
	if player.house_nr == 15:
		for i in range(1,game.nodes.size()):
			game.nodes[i].city_card.pickable = false
		queue_free()
		return
	get_parent().connect("delete_build_action",self,"kill")
	
	highlight_buildable_nodes()

func highlight_buildable_nodes():
	# unhighlight all nodes
	for i in range(1,game.nodes.size()):
		game.nodes[i].city_card.pickable = false
		
	var buildable_nodes = []
	
	var neigh_nodes = []
	# get neighbour nodes
	for colonist in colonists_node.get_children():
		if colonist.between_nodes[0] != 0 and !game.nodes[colonist.between_nodes[0]] in neigh_nodes:
			neigh_nodes.append(game.nodes[colonist.between_nodes[0]])
		if colonist.between_nodes[1] != 0 and !game.nodes[colonist.between_nodes[1]] in neigh_nodes:
			neigh_nodes.append(game.nodes[colonist.between_nodes[1]])
	
	for node in neigh_nodes:
		var house_cost = house_costs[node.city_card.type]
		if house_cost["money"]*node.cost_multiplier >  player.money:
			continue
		var has_all = true
		for item in house_cost["materials"]:
			if !item in player.inventory:
				has_all = false
				break
		if !has_all:
			continue
		buildable_nodes.append(node)
	
	var nr = 0
	for node in buildable_nodes:
		if node in player.houses_on_nodes:
			continue
		nr += 1
		node.city_card.pickable = true
		node.city_card.connect("build_picked",self,"build_picked")
#	if nr == 0 and get_parent().moves_left == 0:
##		for i in range(1,game.nodes.size()):
##			game.nodes[i].city_card.pickable = false
#		player.turn_over()

func build_picked(node):
	get_parent().build_picked(node)
