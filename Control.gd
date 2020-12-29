extends Control

onready var game = get_node("/root/Game")

var items setget set_items
var nr_to_keep setget set_nr_to_keep

func set_items(value):
	items = value

func set_nr_to_keep(value):
	nr_to_keep = value
	if nr_to_keep == 0:
		queue_free()
	get_node("Label").text = "Item overflow! Select " + str(nr_to_keep) + " items\n that you want to keep"

func _ready():
	self.nr_to_keep = 12-game.my_player.inventory.size()
	
	for item in items:
		var new_item_container = GameData.packed_scenes["ItemContainer"].instance()
		new_item_container.type = item
		new_item_container.rect_min_size.x/=2
		new_item_container.rect_size.x/=2
		new_item_container.connect("item_picked",self,"item_picked")
		get_node("HBoxContainer").add_child(new_item_container)
		
		get_node("Background").rect_min_size.y += 80
		get_node("HBoxContainer").rect_min_size.y += 80

func item_picked(item):
	game.my_player.add_to_inventory([item.type])
	item.queue_free()
	self.nr_to_keep -= 1
