extends Node2D

onready var game = get_node("/root/Game")

var buy_cards = [] setget set_buy_cards
var extra_costs = [null,["any"],["any"],["Silk"],["Silk"],["any","Silk"],["Silk","Silk"]]
var card_bought setget set_card_bought

func set_card_bought(value):
	card_bought = value

	var card_node = get_children()[card_bought]

	card_node.get_node("Sprite").texture = null
	card_node.pickable = false

func set_buy_cards(value):
	buy_cards = value
	
	for card in get_children():
		card.queue_free()
	
	for i in range(min(7,buy_cards.size())):
		var buy_card = buy_cards[i]
		var new_buy_card = GameData.packed_scenes["BuyCard"].instance()
		new_buy_card.global_position = Vector2(i*123,0)
		new_buy_card.type = buy_card
		new_buy_card.index = i
		new_buy_card.get_node("Sprite").texture = GameData.card_textures[buy_card]
		add_child(new_buy_card)

