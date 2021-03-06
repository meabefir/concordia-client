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
	game.buy_cards = new_buy_cards
	
	var data = {
		"buy_cards": new_buy_cards
	}
	Server.rpc_id(1,"UpdateNodeById",game.my_id,data)

func _ready():
	for card in game.get_node("BuyCards").get_children():
		card.pickable = true
	player.create_turn_over_button()
	create_buy_card_pick_action()

func create_buy_card_pick_action():
	if cards_bought.size() >= 1:
		player.turn_over()
	var new_buy_card_pick_action = GameData.packed_scenes["BuyCardPickAction"].instance()
	add_child(new_buy_card_pick_action)
	created_instances.append(new_buy_card_pick_action)

func card_picked(card):
	
	for card in game.get_node("BuyCards").get_children():
		card.pickable = false
	
	attempt_to_buy_card(card)
	
	if cards_bought.size() < 1:
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
	for key in card.default_cost:
		if !key in inv_dic:
			has_all = false
			break
		if !(card.default_cost[key] <= inv_dic[key]):
			has_all = false
			break

	if !has_all:
		return
	else:	
		pay_card_cost(card)
		buy_card(card)

func buy_card(card):
	cards_bought.append(card.index)
	player.deck += [card.type]

	deactivate_card(card)
	
func pay_card_cost(card):
#	print(card.default_cost)
	for key in card.default_cost:
		if key == "any":
			continue
		for i in range(card.default_cost[key]):
			player.remove_item_from_inv(key+"Item")

func deactivate_card(card):
#	card.get_node("Sprite").texture = null
#	card.pickable = false
	game.set_card_bought(card.index)
	var data = {
		"card_bought": card.index
	}
	Server.rpc_id(1,"UpdateNodeById",game.my_id,data)
