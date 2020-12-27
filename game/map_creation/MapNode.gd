extends Node2D

var packed_scenes = GameData.packed_scenes

var my_id
var city_type = null setget set_city_type
var land_connections = []
var water_connections = []
var type = null
var travel_cost = 0
var cost_multiplier = 1
var id = 0
var city_card

var child_offset = 20
var child_offsets = [Vector2(-child_offset,-child_offset),Vector2(child_offset,-child_offset),
					 Vector2(-child_offset,child_offset),Vector2(child_offset,child_offset),
					Vector2(0,-child_offset),Vector2(-child_offset,0),Vector2(child_offset,0),Vector2(0,child_offset),
					Vector2(0,0)]
var child_count = 0

func _ready():
	$TypeLabel.text = str(id).to_upper()
	
func _process(delta):
	update()

func set_city_type(value):
	city_type = value
	
	var new_city_card = packed_scenes["CityCard"].instance()
	city_card = new_city_card
	new_city_card.type = city_type
	add_child(new_city_card)

func set_type(typee):
	type = typee
	#$TypeLabel.text = str(type).to_upper()

func connect_land(other_node):
	land_connections.append(other_node)
	
func connect_water(other_node):
	water_connections.append(other_node)
