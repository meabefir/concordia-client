extends Control

var textures = GameData.textures

func update_inventory(inventory):
	
	for i in range(inventory.size()):
		var item_name = inventory[i]
		$Items.get_children()[i].texture = textures[item_name]
		
		if item_name in ["LandColonistItem","WaterColonistItem"]:
			$Items.get_children()[i].modulate = get_node("../../../../").color
			
	# clear textures that remain empty
	for i in range(inventory.size(),12):
		$Items.get_children()[i].texture = null
