extends Node2D

onready var game = get_node("/root/Game")

func kill():
	get_parent().created_instances.erase(self)
	queue_free()

func _ready():
	for card in game.get_node("BuyCards").get_children():
		if card.get_node("Sprite").texture != null:
			card.pickable = true
		card.connect("card_picked",self,"card_picked")

func card_picked(card):
	get_parent().card_picked(card)
	kill()
