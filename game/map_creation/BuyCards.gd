extends Node2D

var buy_cards = [] setget set_buy_cards
var extra_costs = [null,["any"],["any"],["Silk"],["Silk"],["any","Silk"],["Silk","Silk"]]

func set_buy_cards(value):
	buy_cards = value
	
	for i in range(7):
		var buy_card = buy_cards[i]
		var new_buy_card = GameData.packed_scenes["BuyCard"].instance()
		new_buy_card.global_position = Vector2(i*123,0)
		new_buy_card.type = buy_card
		new_buy_card.index = i
		new_buy_card.get_node("Sprite").texture = GameData.card_textures[buy_card]
		add_child(new_buy_card)

