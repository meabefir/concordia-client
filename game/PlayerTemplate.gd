extends Node2D

onready var game = get_node("/root/Game")
onready var colonists = get_node("Colonists")

onready var player_name_label = get_node("CanvasLayer/MainContainer/Container/PlayerName")
onready var money_label = get_node("CanvasLayer/MainContainer/Container/MoneyContainer/Label")
onready var container = get_node("CanvasLayer/MainContainer/Container")
onready var open_close_button = get_node("CanvasLayer/MainContainer/OpenClose")
onready var inventory_node = get_node("CanvasLayer/MainContainer/Container/Inventory")
onready var last_card_node = get_node("CanvasLayer/MainContainer/Container/LastCard")

var has_prefectus = false setget set_has_prefectus
var start_inventory = GameData.start_inventory
var my_id
var player_name = ""
var color = Color(1,1,1)
var my_turn = false
var money = 0 setget set_money
var inventory = [] setget set_inventory
var last_card = null setget set_last_card
var colonist setget set_colonist
var house_nr = 0 setget set_house
var score setget set_score

func set_score(value):
	score = value
	var pos = get_node("CanvasLayer/MainContainer").rect_position
		
	var score_label = GameData.packed_scenes["ScoreLabel"].instance()
	score_label.rect_position = pos
	score_label.text = str(value)
	get_node("CanvasLayer").add_child(score_label)

func set_house(value):
	house_nr = value
	
	get_node("CanvasLayer/MainContainer/Container/HouseCount/Label").text = str(house_nr)

func set_colonist(arr):
	
		add_colonist(arr[0],arr[1])

func set_has_prefectus(value):
	has_prefectus = value
	
	if has_prefectus:
		get_node("CanvasLayer/MainContainer/Container/Prefectus").visible = true
	else:
		get_node("CanvasLayer/MainContainer/Container/Prefectus").visible = false

func set_last_card(card_type):
	last_card = card_type
	
	get_node("CanvasLayer/MainContainer/Container/LastCard").card_type = card_type

func set_my_turn(value):
	my_turn = value

func set_money(value):
	money = value
	
	money_label.text = str(money)
	
func set_inventory(value):
	inventory = value
	
	inventory_node.update_inventory(inventory)
	
func _ready():
	get_node("CanvasLayer/MainContainer/Container/HouseCount/TextureRect").modulate = color
	self.house_nr = 0
	player_name_label.text = player_name
	player_name_label.set("custom_colors/font_color",color)
	
	add_colonist('land',0)
	add_colonist('water',0)

	#get_node("Houses").my_id = randi()

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
	if open_close_button.text == "<<":
		open_close_button.rect_position.x = 0
		open_close_button.text = ">>"
		container.visible = false
	else:
		open_close_button.rect_position.x = 600*.7
		open_close_button.text = "<<"
		container.visible = true
