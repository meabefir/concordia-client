extends Node2D

onready var game = get_node("/root/Game")
onready var colonists = get_node("Colonists")
onready var money_label = get_node("CanvasLayer/MainContainer/Container/MoneyContainer/Label")
onready var container = get_node("CanvasLayer/MainContainer/Container")
onready var open_close_button = get_node("CanvasLayer/MainContainer/OpenClose")
onready var inventory_node = get_node("CanvasLayer/MainContainer/Container/Inventory")
onready var your_turn = get_node("CanvasLayer/MainContainer/YourTurn")

var has_prefectus = false setget set_has_prefectus
var action_playing
var houses_on_nodes = []
var start_inventory = GameData.start_inventory
var my_id
var player_name = ""
var color = Color(1,1,1)
var my_turn = false setget set_my_turn
var money = 0 setget set_money
var inventory = [] setget set_inventory
var deck = [] setget set_deck
var played_cards = [] setget set_played_cards
var last_card setget set_last_card
var colonist setget set_colonist
var house_nr = 0 setget set_house
var colonists_added = []
var score setget set_score
var game_over = false
var copied = null

func set_score(value):
	score = value
	var pos = get_node("CanvasLayer/MainContainer").rect_position
		
	var score_label = GameData.packed_scenes["ScoreLabel"].instance()
	score_label.rect_position = Vector2(1320,750)
	score_label.text = str(value)
	get_node("CanvasLayer").add_child(score_label)
	
func set_score_once(score):
	self.score = score
	
	var data = {
		"score": score
	}
	Server.rpc_id(1,"UpdateNodeById",my_id,data)
	
func calc_score():
	var server_print = {}
	var score = 0
	var cards = deck+played_cards
	server_print["cards"] = cards
	var gods_count = {
		"Jup": 0,
		"Sat": 0,
		"Mer": 0,
		"Mar": 0,
		"Min": 0,
		"Ves": 0
	}
	
	for card in cards:
		gods_count[card.substr(3,3)] += 1
		
	#print(gods_count)
	
	# vesta
	var tota_money = money
	for item in inventory:
		if "Land" in item or "Water" in item:
			continue
		var name = item.substr(0,item.length()-4)
		tota_money += GameData.costs[name]
	var vesta_score = int(tota_money/10)
	server_print["vesta"] = vesta_score
	score += vesta_score
	print("vesta ",vesta_score)
	
	# jupiter
	var god_multipliers = GameData.god_multipliers[game.connected_players.size()]
	var non_brick_cities = 0
	for node in houses_on_nodes:
		if node.city_card.type != "Brick":
			non_brick_cities += 1
	var jupiter_score = non_brick_cities*god_multipliers["Jup"]*gods_count["Jup"]
	server_print["jupiter"] = jupiter_score
	score += jupiter_score
	print("jupieter ",jupiter_score)
	
	# saturnus
	var regions = []
	for region in game.get_node("Regions").get_children():
		for node in houses_on_nodes:
			if node in region.nodes:
				if !region in regions:
					regions.append(region)
	var saturnus_score = regions.size()*god_multipliers["Sat"]*gods_count["Sat"]
	server_print["saturnus"] = saturnus_score
	score += saturnus_score
	print("saturnus ", saturnus_score)
	
	# mercurius
	var goods = {
		"Brick": 0,
		"Food": 0,
		"Anvil": 0,
		"Wine": 0,
		"Silk": 0
	}
	for node in houses_on_nodes:
		goods[node.city_card.type] = 1
	var temp = 0
	for key in goods:
		if goods[key] == 1:
			temp += 2
	var mercurius_score = temp*god_multipliers["Mer"]*gods_count["Mer"]
	server_print["mercurius"] = mercurius_score
	score += mercurius_score
	print("mercurius ", mercurius_score)
	
	# mars
	var mars_score = get_node("Colonists").get_child_count()*2*god_multipliers["Mar"]*gods_count["Mar"]
	server_print["mars"] = mars_score
	score += mars_score
	print("mars ", mars_score)
	
	# minerva
	var minerva_score = 0
	for card in cards:
		if card.substr(3,3) == "Min":
			var card_type = card.substr(0,3)
			var card_resource = GameData.minerva_bullshit2[card_type]
			var multiplier = GameData.minerva_bullshit[card_type]
			var count = 0
			for node in houses_on_nodes:
				if node.city_card.type == card_resource:
					count += 1
			minerva_score += count*multiplier
			score += count*multiplier
	server_print["minerva"] = minerva_score
	print("minerva ",minerva_score)
	set_score_once(score)

	Server.rpc_id(1,"sprint",server_print)

func set_house(value):
	house_nr = value
	
	get_node("CanvasLayer/MainContainer/Container/HouseCount/Label").text = str(house_nr)

func set_colonist(arr):
		add_colonist(arr[0],arr[1])

func set_played_cards(value):
	played_cards = value
	
	get_node("CanvasLayer/MainContainer/Container/PlayedCount").text = str(played_cards.size()) if played_cards.size() != 0 else ""

func set_has_prefectus(value):
	has_prefectus = value
	
	if has_prefectus:
		get_node("CanvasLayer/MainContainer/Container/Prefectus").visible = true
	else:
		get_node("CanvasLayer/MainContainer/Container/Prefectus").visible = false
		
func set_deck(value):
	deck = value
	
	get_node("CanvasLayer/DeckContainer").deck = deck
	
func remove_card_from_deck(card_to_remove):
	var temp_deck = deck.duplicate()
	for card in deck:
		if card == card_to_remove.type:
			temp_deck.erase(card)
			break
	self.deck = temp_deck
	
func set_last_card(card_type):
	last_card = card_type
	get_node("CanvasLayer/MainContainer/Container/LastCard").card_type = card_type
	
	var data = {
		"last_card": card_type
	}
	Server.rpc_id(1,"UpdateNodeById",self.my_id,data)
	
func picked_deck_card(card):
	remove_card_from_deck(card)
	
	played_cards.append(card.type)
	self.played_cards = played_cards
	self.last_card = card.type

	play_card((card.type.substr(0,3)))

func set_my_turn(value):
	my_turn = value

	if my_turn and game_over:
		var data = {
			"name": player_name
		}
		Server.rpc_id(1,"sprint",data)
		game.game_over()
		return

	if my_turn:
		play_turn()		

func set_money(value):
	money = value
	
	var data = {
		"money": money
	}
	Server.rpc_id(1,"UpdateNodeById",my_id,data)
	
	money_label.text = str(money)

func set_inventory(value):
	inventory = value
	
	var data = {
		"inventory": inventory
	}
	Server.rpc_id(1,"UpdateNodeById",my_id,data)
	
	inventory_node.update_inventory(inventory)

func add_to_inventory(items):
	if inventory.size()+items.size() <= 12:
		var temp = inventory.duplicate()
		for item in items:
			temp.append(item+"Item")
		self.inventory = temp
	else:
		# item overflow !
		var new_item_overflow = GameData.packed_scenes["ItemOverflow"].instance()
		new_item_overflow.items = items
		get_node("CanvasLayer").add_child(new_item_overflow)

func remove_item_from_inv(item):
	var inv_cpy = inventory.duplicate()
	inv_cpy.erase(item)
	self.inventory = inv_cpy

func play_card(card_type):
	match card_type:
		"Arc":
			play_architect()
		"Pre":
			play_prefect()
		"Mer":
			play_mercator()
		"Sen":
			play_senator()
		"Con":
			play_consul()
		"Col":
			play_colonist()
		"Mas":
			play_farmer()
		"Far":
			play_farmer()
		"Smi":
			play_farmer()
		"Vin":
			play_farmer()
		"Wea":
			play_farmer()
		"Dip":
			play_diplomat()
		"Tri":
			play_tribune()

func play_architect():
	action_playing = GameData.packed_scenes["ArchitectAction"].instance()
	add_child(action_playing)
	
func play_prefect():
	action_playing = GameData.packed_scenes["PrefectAction"].instance()
	add_child(action_playing)
	
func play_mercator():
	action_playing = GameData.packed_scenes["MercatorAction"].instance()
	add_child(action_playing)
	
func play_senator():
	action_playing = GameData.packed_scenes["SenatorAction"].instance()
	add_child(action_playing)
	
func play_consul():
	action_playing = GameData.packed_scenes["ConsulAction"].instance()
	add_child(action_playing)
	
func play_colonist():
	action_playing = GameData.packed_scenes["ColonistAction"].instance()
	add_child(action_playing)
	
func play_farmer():
	action_playing = GameData.packed_scenes["FarmerAction"].instance()
	add_child(action_playing)
	
func play_diplomat():
	action_playing = GameData.packed_scenes["DiplomatAction"].instance()
	add_child(action_playing)
	
func play_tribune():
	action_playing = GameData.packed_scenes["TribuneAction"].instance()
	add_child(action_playing)
	
func play_turn():
	your_turn.visible = true
	create_card_pick_action()
	
func create_card_pick_action():
	var new_card_pick_action = GameData.packed_scenes["CardPickAction"].instance()
	add_child(new_card_pick_action)
	
func turn_over(last_turn = false):
	your_turn.visible = false
	if action_playing != null:
		if "created_instances" in action_playing:
			for instance in action_playing.created_instances:
				instance.kill()
		if action_playing.has_method("cleanup"):
			action_playing.cleanup()
		action_playing.queue_free()
	delete_turn_over_button()
	
	if last_turn:
		Server.rpc_id(1,"sprint","set last turn for player "+str(player_name))
		game_over = true
	game.next_turn()
#	if !game_over:
#		game.next_turn()
#	else:
#		game.game_over()
	
func _ready():
	get_node("CanvasLayer/MainContainer/Container/HouseCount/TextureRect").modulate = color
	self.house_nr = 0
	
	add_colonist('land',0)
	add_colonist('water',0)
	
	#get_node("Houses").my_id = randi()
	# danger
	# create houses
	for i in range(15):
		var new_house = GameData.packed_scenes["House"].instance()
		new_house.my_id = randi()
		get_node("Houses").add_child(new_house)
	# danger
	
	self.inventory = start_inventory
	self.deck = GameData.starting_deck

func add_colonist(type,node_id):
	var new_colonist
	if type == 'land':
		# add to inv !!!!!!!!!!!!
		new_colonist = GameData.packed_scenes["LandColonist"].instance()
		new_colonist.type = 1
	else:
		new_colonist = GameData.packed_scenes["WaterColonist"].instance()
		new_colonist.type = 2
	new_colonist.between_nodes = [node_id,node_id]
	new_colonist.standing_on = node_id
	# add to map
	new_colonist.global_position = game.nodes[node_id].global_position+game.nodes[node_id].child_offsets[game.nodes[node_id].child_count]
	game.nodes[node_id].child_count += 1
	new_colonist.owned_by = self
	new_colonist.my_id = randi()
	get_node("Colonists").add_child(new_colonist)


func _on_OpenClose_pressed():
	if open_close_button.text == "V":
		open_close_button.rect_position.y = 1032
		open_close_button.text = "^"
		container.visible = false
	else:
		open_close_button.rect_position.y = 700
		open_close_button.text = "V"
		container.visible = true

func create_turn_over_button():
	var turn_over_button = GameData.packed_scenes["TurnOver"].instance()
	get_node("CanvasLayer").add_child(turn_over_button)

func delete_turn_over_button():
	if get_node("CanvasLayer").has_node("TurnOver"):
		get_node("CanvasLayer/TurnOver").queue_free()
