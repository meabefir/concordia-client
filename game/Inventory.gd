extends Control

var init = 0
var textures = GameData.textures

onready var item_slot_scene = preload("res://game/UI/ItemSlot.tscn")

func update_inventory(inventory):
	if init == 0:
		init_item_slots(inventory)
	
	for i in range(inventory.size()):
		var item_name = inventory[i]
		$Items.get_children()[i].texture = textures[item_name]
		$Items.get_children()[i].type = item_name.substr(0,item_name.length()-4)
		
		if item_name in ["LandColonistItem","WaterColonistItem"]:
			$Items.get_children()[i].modulate = get_node("../../../../").color
			
	# clear textures that remain empty
	for i in range(inventory.size(),12):
		$Items.get_children()[i].texture = null
		$Items.get_children()[i].type = null

func init_item_slots(inventory):
	init = 1
	for i in range(12):
		var new_item_slot = item_slot_scene.instance()
		var row = int(i/6)
		var col = i%6
		new_item_slot.rect_position = Vector2(35+col*69,65+row*100)
		if inventory.size() > i:
			new_item_slot.type = inventory[i]
		get_node("Items").add_child(new_item_slot)
