extends Node2D

signal delete_pick_connection
signal delete_build_action

onready var player = get_parent()
onready var game = get_node("/root/Game")
onready var colonist_pick_scene = preload("res://game/card_actions/architect/ColonistPick.tscn")
onready var connection_pick_scene = preload("res://game/card_actions/architect/ConnectionPick.tscn")
onready var build_action_scene = preload("res://game/card_actions/architect/BuildAction.tscn")

var colonist_picked = null setget set_colonist
var moves_left = 0

func cleanup():
	unhighlight_existing_connections()
	if colonist_picked != null:
		unhighlight_colonist(colonist_picked)
	for i in range(1,game.nodes.size()):
		game.nodes[i].city_card.pickable = false

func _ready():
	player.create_turn_over_button()
#	print("arhi action")
	moves_left = player.colonists.get_child_count()
	create_colonist_pick()
	create_build_action()
		
func create_colonist_pick():
	var new_colonist_pick = colonist_pick_scene.instance()
	add_child(new_colonist_pick)
	emit_signal("delete_pick_connection")

func create_build_action():
	emit_signal("delete_build_action")
	var new_build_action = build_action_scene.instance()
	add_child(new_build_action)
		
func create_connection_pick():
	var temp_connection_pick = connection_pick_scene.instance()
	add_child(temp_connection_pick)
		
func set_colonist(colonist):
#	print("Picked colonist"+str(colonist))
	# reset last colonist if it exists
	if colonist_picked != null:
		unhighlight_colonist(colonist_picked)
	
	#add new colonist_pick, if player wants to change it
	create_colonist_pick()
	
	# if selected same colonist again
	if colonist_picked == colonist:
		unhighlight_colonist(colonist)
		colonist_picked = null
		unhighlight_existing_connections()
		return
	
	colonist_picked = colonist
	
	highlight_colonist(colonist_picked)
	
	create_connection_pick()
	
func picked_connection(connection):
	unhighlight_existing_connections()
	var offset = connection.curve.get_baked_length()/2
	connection.get_node("Path2D/PathFollow2D").offset = offset
	
	# DO STUFF TO COLONIST !!!!!!!!!!!!
	colonist_picked.global_position = connection.get_node("Path2D/PathFollow2D").global_position
	# server update colonist position
	var data = {
		"global_position": colonist_picked.global_position
	}
	Server.rpc_id(1,"UpdateNodeById",colonist_picked.my_id,data)
	
	if typeof(colonist_picked.standing_on) != TYPE_INT:
		colonist_picked.standing_on.occupied = false
		# server update connection occupied
		data = {
			"occupied": false
		}
		Server.rpc_id(1,"UpdateNodeById",colonist_picked.standing_on.my_id,data)
	colonist_picked.standing_on = connection
	connection.occupied = true
	# server update connection occupied
	data = {
		"occupied": true
	}
	Server.rpc_id(1,"UpdateNodeById",connection.my_id,data)
	colonist_picked.between_nodes = connection.between_nodes
	
	unhighlight_colonist(colonist_picked)
	colonist_picked = null
	
	# create build action
	create_build_action()
	
	# subtract number of moves
	moves_left -= connection.cost
	connection.cost = 0
	
#	print("moves left"+str(moves_left))
	
func build_picked(node):
	var data
	moves_left = 0
	emit_signal("delete_pick_connection")
	player.houses_on_nodes.append(node)
	
	#build house on that node 
	player.get_node("Houses").get_children()[player.house_nr].global_position = node.global_position+node.child_offsets[node.child_count]
	player.get_node("Houses").get_children()[player.house_nr].visible = true
	player.get_node("Houses").get_children()[player.house_nr].node = node
	node.child_count += 1
	player.house_nr += 1
	if player.house_nr == 15:
		game.game_over()
	# update house built on all clients
	data = {
		"global_position": player.get_node("Houses").get_children()[player.house_nr-1].global_position,
		"visible": true
	}
	Server.rpc_id(1,"UpdateNodeById",player.get_node("Houses").get_children()[player.house_nr-1].my_id,data)
	# update player houses_nr variable
	data = {
		"house_nr": player.house_nr
	}
	Server.rpc_id(1,"UpdateNodeById",player.my_id,data)
	#remove materials and money from inventory hehehehe
	player.money -= GameData.house_costs[node.city_card.type]["money"]*node.cost_multiplier
	for item in GameData.house_costs[node.city_card.type]["materials"]:
		player.remove_item_from_inv(item)
#	data = {
#		"money": player.money,
#		"inventory": player.inventory
#	}
#	Server.rpc_id(1,"UpdateNodeById",player.my_id,data)
	
	# increase cost multiplier
	node.cost_multiplier += 1 
	data = {
		"cost_multiplier": node.cost_multiplier,
		"child_count": node.child_count
	}
	Server.rpc_id(1,"UpdateNodeById",node.my_id,data)
	
	create_build_action()

func unhighlight_existing_connections():
	for connection in game.connections:
		if connection.highlighted:
			connection.set_highlight(false)
	
func highlight_colonist(colonist):
	colonist.get_node("Sprite").get("material").set_shader_param("outline_color",Color(1,1,1))
	colonist.get_node("Sprite").get("material").set_shader_param("width",4)
	
func unhighlight_colonist(colonist):
	colonist.get_node("Sprite").get("material").set_shader_param("outline_color",Color(0,0,0))
	colonist.get_node("Sprite").get("material").set_shader_param("width",2)
