extends Node2D

onready var game = get_node("/root/Game")

var type = null
var between_nodes = null
var connections_to_highlight = []
var bfs_visited = []

func kill():
	get_parent().unhighlight_existing_connections()
	queue_free()

func _ready():
	get_parent().connect("delete_pick_connection",self,"kill")
	type = get_parent().colonist_picked.type
	between_nodes = get_parent().colonist_picked.between_nodes
	
	get_parent().unhighlight_existing_connections()
	highlight_close_connections()

func picked_connection(connection):
	get_parent().picked_connection(connection)
	kill()

func highlight_close_connections():
	var queue = []
	var visited = []
	
	queue.append([between_nodes,0])
	if typeof(get_parent().colonist_picked.standing_on) != TYPE_INT:
		visited.append(get_parent().colonist_picked.standing_on)
	
	while queue.size() and queue[0][1] <= get_parent().moves_left:
		for connection in game.connections:
			if connection.node1.id in queue[0][0] or connection.node2.id in queue[0][0]:
				if !connection in visited and connection.type == type:
					visited.append(connection)
					connection.cost = queue[0][1]+1
					queue.append([connection.between_nodes,queue[0][1]+1])
		queue.pop_front()
	
	for connection in visited:
		if connection.cost <= get_parent().moves_left and !connection.occupied:
			connection.connect("picked_connection",self,"picked_connection")
			connection.set_highlight(true)
