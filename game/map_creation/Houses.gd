extends Node2D

#onready var house_scene = preload("res://game/pieces/House.tscn")
#
#var my_id
#var houses = [] setget set_houses
#
#func set_houses(value):
#	houses = value
#
#	var new_house = house_scene.instance()
#	new_house.node = houses[-1]
#	new_house.global_position = new_house.node.global_position+new_house.node.child_offsets[new_house.node.child_count]
#	add_child(new_house)
#	houses[-1] = new_house
#
#	new_house.node.cost_multiplier += 1 
#	new_house.node.child_count += 1
#	var data = {
#		"cost_multiplier": new_house.node.cost_multiplier,
#		"child_count": new_house.node.child_count
#	}
#	Server.rpc_id(1,"UpdateNodeById",new_house.node.my_id,data)
#
#func set_houses_once(value):
#
#	var data = {
#		"houses": value
#	}
#	Server.rpc_id(1,"UpdateNodeById",my_id,data)
#
#	self.houses = value
#
#func add_house(node):
#	var temp = houses.duplicate()
#	temp.append(node)
#
#	set_houses_once(temp)
