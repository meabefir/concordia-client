extends Node2D

onready var game = get_node("/root/Game")
onready var player = get_parent()

func cleanup():
	for region in game.get_node("Regions").get_children():
		region.pickable = false

func _ready():
	for region in game.get_node("Regions").get_children():
		if region.active:
			region.pickable = true
			region.connect("region_picked",self,"region_picked")

	game.get_node("MoneyGrabRegion").pickable = true
	game.get_node("MoneyGrabRegion").connect("money_grabbed",self,"money_grabbed")

func money_grabbed():
	# give money from regions
	var money_to_make = 0
	for region in game.get_node("Regions").get_children():
		if !region.active:
			money_to_make += region.get_node("RegionToken").value
		
		# set all back to active
		region.set_active_once(true)
		
	# update player money
	player.money += money_to_make
		
	reset_all_regions()
	
	player.turn_over()

func region_picked(region):
	region.set_active_once(false)
	
	reset_all_regions()
	
	# GIVE RESOURCES TO ALL
	region.yield_all_resources()
	
	# give prefectus to next player
	if player.has_prefectus:
		# give the next player the card
		var network_id = get_tree().get_network_unique_id()
		var my_index = game.connected_players.find(network_id)
		var next_index = (my_index+1)%game.connected_players.size()
#		print(next_index)
		for i in range(game.connected_players_nodes.size()):
			var connected_player = game.connected_players_nodes[i]
			if i == next_index:
				connected_player.has_prefectus = true
			else:
				connected_player.has_prefectus = false
			var data = {
				"has_prefectus": connected_player.has_prefectus
			}
			Server.rpc_id(1,"UpdateNodeById",connected_player.my_id,data)
	
	# turn over
	player.turn_over()
	
func reset_all_regions():
	for region in game.get_node("Regions").get_children():
		region.pickable = false
	game.get_node("MoneyGrabRegion").pickable = false
