extends Node2D

onready var game = get_node("/root/Game")
onready var colonists = get_node("Colonists")
onready var money_label = get_node("CanvasLayer/MainContainer/Container/MoneyContainer/Label")
onready var container = get_node("CanvasLayer/MainContainer/Container")
onready var open_close_button = get_node("CanvasLayer/MainContainer/OpenClose")
onready var inventory_node = get_node("CanvasLayer/MainContainer/Container/Inventory")

var action_playing
var houses_on_nodes = []
var house_nr = 0
var start_inventory = GameData.start_inventory
var my_id
var player_name = ""
var color = Color(1,1,1)
var my_turn = false setget set_my_turn
var money = 0 setget set_money
var inventory = [] setget set_inventory

func set_my_turn(value):
	my_turn = value

	if my_turn:
		play_turn()

func set_money(value):
	money = value
	
	money_label.text = str(money)

func set_inventory(value):
	inventory = value
	
	inventory_node.update_inventory(inventory)

func remove_item_from_inv(item):
	var inv_cpy = inventory.duplicate()
	inv_cpy.erase(item)
	self.inventory = inv_cpy

func play_card(card_type):
	match card_type:
		"architect":
			play_architect()

func play_architect():
	action_playing = GameData.packed_scenes["ArchitectAction"].instance()
	add_child(action_playing)
	
func play_turn():
	#yield(get_tree().create_timer(.5),"timeout")
	play_card("architect")
	
func turn_over():
	action_playing.queue_free()
	if get_node("CanvasLayer").has_node("TurnOver"):
		get_node("CanvasLayer/TurnOver").queue_free()
	game.next_turn()
	
func _ready():
	add_colonist('land',0)
	add_colonist('water',0)
	
	# create houses
	for i in range(15):
		var new_house = GameData.packed_scenes["House"].instance()
		new_house.my_id = randi()
		get_node("Houses").add_child(new_house)
	
	self.inventory = start_inventory

func add_colonist(type,node_id):
	var new_colonist
	if type == 'land':
		# add to inv !!!!!!!!!!!!
		new_colonist = GameData.packed_scenes["LandColonist"].instance()
		new_colonist.type = 1
	else:
		new_colonist = GameData.packed_scenes["WaterColonist"].instance()
		new_colonist.type = 2
	new_colonist.between_nodes = [node_id,node_id]
	new_colonist.standing_on = node_id
	# add to map
	new_colonist.global_position = game.nodes[node_id].global_position+game.nodes[node_id].child_offsets[game.nodes[node_id].child_count]
	game.nodes[node_id].child_count += 1
	new_colonist.owned_by = self
	new_colonist.my_id = randi()
	get_node("Colonists").add_child(new_colonist)


func _on_OpenClose_pressed():
	if open_close_button.text == "V":
		open_close_button.rect_position.y = 1032
		open_close_button.text = "^"
		container.visible = false
	else:
		open_close_button.rect_position.y = 704
		open_close_button.text = "V"
		container.visible = true

func create_turn_over_button():
	var turn_over_button = GameData.packed_scenes["TurnOver"].instance()
	get_node("CanvasLayer").add_child(turn_over_button)
	
