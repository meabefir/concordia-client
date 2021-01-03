extends Control

var buy_dic = {}
var sell_dic = {}
var dic = {}

onready var game = get_node("/root/Game")

func kill():
	for item_slot in game.my_player.get_node("CanvasLayer/MainContainer/Container/Inventory/Items").get_children():
		item_slot.pickable = false
	queue_free()

func _ready():
	for key in GameData.costs:
		var new_item_container = GameData.packed_scenes["ItemContainer"].instance()
		new_item_container.type = key
		new_item_container.connect("item_picked",self,"shop_item_picked")
		get_node("HBoxContainer").add_child(new_item_container)

	make_inv_items_pickable()

func make_inv_items_pickable():
	for item_slot in game.my_player.get_node("CanvasLayer/MainContainer/Container/Inventory/Items").get_children():
		item_slot.pickable = false
		if item_slot.is_connected("slot_item_picked",self,"inv_item_picked"):
			item_slot.disconnect("slot_item_picked",self,"inv_item_picked")
		if item_slot.type in ["LandColonist","WaterColonist",null]:
			continue

		item_slot.pickable = true
		item_slot.update()
		if !item_slot.is_connected("slot_item_picked",self,"inv_item_picked"):
			item_slot.connect("slot_item_picked",self,"inv_item_picked")
		
func shop_item_picked(item):
	var item_cost = GameData.costs[item.type]
	if item_cost <= game.my_player.money:
		if dic.size() <= 2:
			if item.type in dic:
				attempt_buy(item.type)
			elif !item.type in dic and dic.size() < 2:
				dic[item.type] = 1
				attempt_buy(item.type)
		
func inv_item_picked(item):
	if item.type in ["LandColonist","WaterColonist",null]:
		return
	if dic.size() <= 2:
		if item.type in dic:
			attempt_sell(item.type)
		elif !item.type in dic and dic.size() < 2:
			dic[item.type] = 1
			attempt_sell(item.type)

func attempt_buy(item_type):
	if game.my_player.inventory.size() >= 12:
		return
	var item_cost = GameData.costs[item_type]
	game.my_player.money -= item_cost
	game.my_player.add_to_inventory([item_type])
	make_inv_items_pickable()
		
func attempt_sell(item_type):
	if item_type == null:
		return
	game.my_player.money += GameData.costs[item_type]
	game.my_player.remove_item_from_inv(item_type+"Item")
	make_inv_items_pickable()
