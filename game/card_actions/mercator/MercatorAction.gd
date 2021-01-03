extends Node2D

onready var player = get_parent()

var created_instances = []

func _ready():
	var last_card = player.copied if player.copied != null else player.last_card
	if last_card.length() > 6:
		player.money += 5
	else:
		player.money += 3
	player.create_turn_over_button()
	create_shop_window()

func create_shop_window():
	var new_shop_window = GameData.packed_scenes["ShopWindow"].instance()
	player.get_node("CanvasLayer").add_child(new_shop_window)
	created_instances.append(new_shop_window)
