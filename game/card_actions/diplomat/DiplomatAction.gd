extends Node2D

onready var game = get_node("/root/Game")
onready var player = get_parent()

func _ready():
	var none = true
	for player_template in game.connected_template_players_nodes:
		if player_template.last_card == null:
			continue
		if player_template.last_card.substr(0,3) != "Dip":
			player_template.last_card_node.pickable = true
			player_template.last_card_node.connect("last_card_picked",self,"last_card_picked")
			none = false
	if none:
		player.turn_over()
	
func last_card_picked(card):
	player.play_card((card.substr(0,3)))
	
	for player_template in game.connected_template_players_nodes:
		player_template.last_card_node.pickable = false
	queue_free()
