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
var house_nr = 0
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
		var temp = inventory
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
	
func play_turn():
	your_turn.visible = true
	create_card_pick_action()
	
func create_card_pick_action():
	var new_card_pick_action = GameData.packed_scenes["CardPickAction"].instance()
	add_child(new_card_pick_action)
	
func turn_over():
	your_turn.visible = false
	if "created_instances" in action_playing:
		for instance in action_playing.created_instances:
			instance.kill()
	if action_playing.has_method("cleanup"):
		action_playing.cleanup()
	action_playing.queue_free()
	if get_node("CanvasLayer").has_node("TurnOver"):
		get_node("CanvasLayer/TurnOver").queue_free()
	game.next_turn()
	
func _ready():
	
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
