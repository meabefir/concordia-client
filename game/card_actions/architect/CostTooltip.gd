extends Control

var node = null setget set_node

func set_node(value):
	node = value	
	
	var type = node.type
	var materials_cost = GameData.house_costs[type]["materials"]
	var money_cost = GameData.house_costs[type]["money"]*node.get_parent().cost_multiplier

	get_node("MoneyContainer/Label").text = str(money_cost)

	for material in materials_cost:
		var new_item_container = GameData.packed_scenes["ItemContainer"].instance()
		new_item_container.get_node("TextureRect").texture = GameData.textures[material]
		get_node("VBoxContainer").add_child(new_item_container)
		
		get_node("Background").rect_min_size.y += 80
		
func _process(delta):
	rect_position = get_viewport().get_mouse_position()+Vector2(100,-get_node("Background").rect_min_size.y/2)
	
