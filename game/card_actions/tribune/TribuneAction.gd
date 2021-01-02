extends Node2D

onready var player = get_parent()

func cleanup():
	for item in player.inventory_node.get_node("Items").get_children():
		item.pickable = false

func _ready():
	player.money += max(0,player.played_cards.size()-3)
	player.deck += player.played_cards
	player.played_cards = []
	player.last_card = null
	
	if "AnvilItem" in player.inventory and "FoodItem" in player.inventory:
		if "LandColonistItem" in player.inventory or "WaterColonistItem" in player.inventory:
			create_yes_no_tooltip()
	else:
		player.turn_over()

func create_yes_no_tooltip():
	var new_yes_no_tooltip = GameData.packed_scenes["YesNoTooltip"].instance()
	new_yes_no_tooltip.connect("yesno",self,"yesno")
	add_child(new_yes_no_tooltip)

func yesno(answer):
	if answer == "yes":
		create_colonist_pick()
	else:
		player.turn_over()

func create_colonist_pick():
	var new_colonist_pick = GameData.packed_scenes["ColonistPick"].instance()
	add_child(new_colonist_pick)

func colonist_picked(item):

	var type = "water" if item.type == "WaterColonist" else "land"
	player.remove_item_from_inv(item.type+"Item")
	player.remove_item_from_inv("FoodItem")
	player.remove_item_from_inv("AnvilItem")
	player.add_colonist(type,0)
	var data = {
		"colonist": [type,0]
	}
	Server.rpc_id(1,"UpdateNodeById",player.my_id,data)
	player.turn_over()
