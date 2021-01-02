extends CanvasLayer

onready var game = get_node("/root/Game")
onready var player = get_parent().player

var cost
var card

func _ready():
	if player.get_node("CanvasLayer").has_node("TurnOver"):
		player.get_node("CanvasLayer/TurnOver").queue_free()
	
	for card in game.get_node("BuyCards").get_children():
		card.pickable = false
	
	
#	for key in cost:
#		if key == "any":
#			continue
#		else:
#			for i in range(cost[key]):
	for item_slot in player.inventory_node.get_node("Items").get_children():
		if !item_slot.pickable and !item_slot.type in ["LandColonist","WaterColonist"]:
			item_slot.pickable = true
			item_slot.connect("slot_item_picked",self,"slot_item_picked")

func slot_item_picked(slot):
	for item_slot in player.inventory_node.get_node("Items").get_children():
		item_slot.pickable = false
	player.remove_item_from_inv(slot.type+"Item")
	get_parent().any_picked(card)
	queue_free()
