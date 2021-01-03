extends Node2D

onready var game = get_node("/root/Game")
onready var player = get_parent()

var created_instances = []
var cards_bought = []

func cleanup():
	var old_buy_cards = game.get_node("BuyCards").buy_cards
	var new_buy_cards = []
	for i in range(old_buy_cards.size()):
		if i in cards_bought:
			continue
		new_buy_cards.append(old_buy_cards[i])
	if new_buy_cards.size() != 0:
		game.buy_cards = new_buy_cards
	else:
		game.last_turn()
	
	var data = {
		"buy_cards": new_buy_cards
	}
	Server.rpc_id(1,"UpdateNodeById",game.my_id,data)

func _ready():
	for card in game.get_node("BuyCards").get_children():
		card.pickable = true
	create_buy_card_pick_action()

func create_buy_card_pick_action():
	if cards_bought.size() >= 2:
		player.turn_over()
		return
	var new_buy_card_pick_action = GameData.packed_scenes["BuyCardPickAction"].instance()
	if !player.has_node("CanvasLayer/TurnOver"):
		player.create_turn_over_button()
	add_child(new_buy_card_pick_action)
	created_instances.append(new_buy_card_pick_action)

func card_picked(card):
	
	for card in game.get_node("BuyCards").get_children():
		card.pickable = false
	
	attempt_to_buy_card(card)
	
	if cards_bought.size() < 2:
		if !has_node("PickAnyResource"):
			create_buy_card_pick_action()
	else:
		player.turn_over()

func attempt_to_buy_card(card):
	var inv_dic = {}
	for item in player.inventory:
		var name = item.substr(0,item.length()-4)
		if name in inv_dic:
			inv_dic[name] += 1
		else:
			inv_dic[name] = 1
		
	var has_all = true
	for key in card.cost:
		if key == "any":
			continue
		if !key in inv_dic:
			has_all = false
			break
		if !(card.cost[key] <= inv_dic[key]):
			has_all = false
			break

	if !has_all:
		return
	
	if !"any" in card.cost:
		if has_all:
			pay_card_cost(card)
			buy_card(card)
	else:
		var nr_items = 0
		for item in player.inventory:
			if !item in ["LandColonistItem","WaterColonistItem"]:
				nr_items += 1
		var nr_needed = 0
		for key in card.cost:
			if key != "any":
				nr_needed += inv_dic[key]
		
		if nr_items <= nr_needed:
			return
		pay_card_cost(card)
		pay_any_resource(card)

func pay_any_resource(card):
	player.delete_turn_over_button()
	var pick_any = GameData.packed_scenes["PickAny"].instance()
	pick_any.cost = card.cost
	pick_any.card = card
	add_child(pick_any)

func any_picked(slot):
	buy_card(slot)
	create_buy_card_pick_action()

func buy_card(card):
	cards_bought.append(card.index)
	player.deck += [card.type]

	deactivate_card(card)
	
func pay_card_cost(card):
	for key in card.cost:
		if key == "any":
			continue
		for i in range(card.cost[key]):
			player.remove_item_from_inv(key+"Item")

func deactivate_card(card):
#	card.get_node("Sprite").texture = null
#	card.pickable = false
	game.set_card_bought(card.index)
	var data = {
		"card_bought": card.index
	}
	Server.rpc_id(1,"UpdateNodeById",game.my_id,data)
