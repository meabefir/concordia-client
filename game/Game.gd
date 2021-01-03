extends Node2D

var my_id
var nr_nodes = 31
var nodes = []
var connections = []
var regions = []
var buy_cards = [] setget set_buy_cards
var region_nodes = GameData.region_nodes
var starting_deck = GameData.starting_deck
var buy_cards_data = GameData.buy_cards_data
var nodes_coords = GameData.nodes_coords
var city_cards = GameData.city_cards
var regions_data = GameData.regions_data
var connections_data = GameData.connections
var node_types = GameData.node_types
var packed_scenes = GameData.packed_scenes
var connection_paths = GameData.connection_paths
var my_player
var card_bought setget set_card_bought
var over = false setget set_game_over

var land_graph = []
var water_graph = []

var connected_template_players_nodes = []
var connected_players = [] setget set_connected_players
var connected_players_nodes = []
var player_data = {} setget set_players_data

var turn = 0 setget set_turn

func set_game_over(value):
	over = value
	
	if over == true:
		my_player.calc_score()

func last_turn():
	my_player.game_over = true

func game_over():
	print("OVER")
	self.over = true
	var data = {
		"over": true
	}
	Server.rpc_id(1,"UpdateNodeById",my_id,data)
	#my_player.turn_over(true)

func set_card_bought(value):
	card_bought = value
	
	get_node("BuyCards").card_bought = card_bought

func set_buy_cards(value):
	buy_cards = value
	
	get_node("BuyCards").buy_cards = buy_cards

func set_players_data(value):
	player_data = value

func set_connected_players(value):
	connected_players = value

func set_turn(new_turn):
	connected_players_nodes[turn].my_turn = false
	turn = new_turn
	connected_players_nodes[turn].my_turn = true
	
func next_turn():
	self.turn = (turn+1)%connected_players.size()

	var data = {
		"turn": turn
	}
	Server.rpc_id(1,"UpdateNodeById",self.my_id,data)

func _input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func init_0(graph):
	for i in range(nr_nodes):
		var row = []
		for j in range(nr_nodes):
			row.append(0)
		graph.append(row)

func _init():
	init_0(land_graph)
	init_0(water_graph)

func _ready():
	my_id = randi()
	# create nodes
	for node in nodes_coords:
		var new_node = packed_scenes['MapNode'].instance()
		new_node.global_position = Vector2(node.x,node.y)
		new_node.id = nodes.size()
		get_node("Nodes").add_child(new_node)
		
		# set node type
		new_node.set_type(node_types[nodes.size()])
		new_node.my_id = randi()
		nodes.append(new_node)

	# assign city card to nodes
	city_cards.shuffle()
	for i in range(1,nodes.size()):
		nodes[i].city_type = city_cards.pop_front()

	# create regions
	for i in range(regions_data.size()):
		var data = regions_data[i]
		var new_region = packed_scenes["Region"].instance()
		for node in region_nodes[i]:
			new_region.nodes.append(nodes[node])
		new_region.my_id = randi()
		new_region.index = i
		get_node("Regions").add_child(new_region)
		new_region.create_collision(data)

	# create connections
	for connection in connections_data:
		var type = connection[0]
		var node1 = connection[1]
		var node2 = connection[2]
		var path = connection_paths.pop_front()
		
		if land_graph[node1][node2] == 1 and type == 1:
			continue
		if water_graph[node1][node2] == 1 and type == 2:
			continue
		
		if type == 1:
			nodes[node1].connect_land(nodes[node2])
			nodes[node2].connect_land(nodes[node1])
			land_graph[node1][node2] = 1
			land_graph[node2][node1] = 1
		else:
			nodes[node1].connect_water(nodes[node2])
			nodes[node2].connect_water(nodes[node1])
			water_graph[node1][node2] = 1
			water_graph[node2][node1] = 1
		
		var new_connection = packed_scenes["Connection"].instance()
		new_connection.node1 = nodes[node1]
		new_connection.node2 = nodes[node2]
		new_connection.type = type
		new_connection.between_nodes = [node1,node2]
		new_connection.path = path
		new_connection.create_collision()
		new_connection.create_curve()
		get_node("Connections").add_child(new_connection)
		
		new_connection.my_id = randi()
		connections.append(new_connection)
	
	# create buy cards deck
	for tier in buy_cards_data:
		var temp = tier.duplicate()
		temp.shuffle()
		
		for card in temp:
			buy_cards.append(card)
	 
	get_node("BuyCards").set_buy_cards(buy_cards)
#	var temp = []
#	for i in range(1):
#		temp.append(buy_cards[i])
#	get_node("BuyCards").set_buy_cards(temp)

	
func init_players():
	# init players
	var template_players = 0
	var self_id = get_tree().get_network_unique_id()
	for id in connected_players:
		var new_player
		if self_id == id:
			new_player = packed_scenes["Player"].instance()
			my_player = new_player
			for region in get_node("Regions").get_children():
				region.player = my_player
			#new_player.my_turn = true # !!!!!!!!!!!!!!!!!!!!!! temp
		else:
			new_player = packed_scenes["PlayerTemplate"].instance()
			connected_template_players_nodes.append(new_player)
			new_player.get_node("CanvasLayer/MainContainer").rect_position.y = template_players*328*.7
			template_players += 1
		
		new_player.my_id = randi()
		connected_players_nodes.append(new_player)
		
		new_player.color = player_data[id]["color"]
		new_player.player_name = player_data[id]["player_name"]
		
		get_node("Players").add_child(new_player)
		
		new_player.name = str(id)
		new_player.money = player_data[id]["money"]
	
		# first player starts
		if connected_players_nodes.size() == 1:
			new_player.my_turn = true
		if id == connected_players[-1]:
			new_player.has_prefectus = true


func _on_Regions_mouse_exited():
	pass # Replace with function body.
