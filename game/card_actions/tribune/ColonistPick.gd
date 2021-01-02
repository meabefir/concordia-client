extends Node2D

onready var player = get_node("../../")

func _ready():
	for item in player.inventory_node.get_node("Items").get_children():
		if item.type in ["LandColonist","WaterColonist"]:
			item.pickable = true
			item.connect("slot_item_picked",self,"colonist_picked")

func colonist_picked(item):
	get_parent().colonist_picked(item)
	queue_free()
