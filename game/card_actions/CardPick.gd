extends Node2D

onready var card_container = get_node("../CanvasLayer/DeckContainer")

func _ready():
	for card in card_container.get_children():
		card.pickable = true
		card.connect("picked_deck_card",self,"picked_deck_card")

func picked_deck_card(card):
	get_parent().picked_deck_card(card)
	queue_free()
