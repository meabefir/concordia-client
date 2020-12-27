extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "meabefir.go.ro"
var port = 4600

var lobby_player_template_scene = preload("res://lobby/LobbyPlayerTemplate.tscn")

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _ready():
	pass
	#ConnectToServer(ip)

func ConnectToServer(ip):
	print("CONNECTING TO "+str(ip))
	network.create_client(ip,port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed",self,"_OnConnectionFailed")
	network.connect("connection_succeeded",self,"_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect")
	
func _OnConnectionSucceeded():
	get_tree().change_scene("res://lobby/Lobby.tscn")
	print("Successfully connected")
	
remote func SetRandomSeed(random_seed):
	seed(random_seed)

remote func UpdateLobbyPlayerData(player_id,data):
	var player_container = get_node("/root/Lobby/PlayersContainer")
	if !player_container.has_node(str(player_id)):
		var new_lobby_player_template = lobby_player_template_scene.instance()
		new_lobby_player_template.name = str(player_id)
		player_container.add_child(new_lobby_player_template)
	var node = get_node("/root/Lobby/PlayersContainer/"+str(player_id))
	for key in data:
		node.set(key,data[key])

remote func PlayerDisconnected(player_id):
	if !GameData.game_started:
		get_node("/root/Lobby/PlayersContainer/"+str(player_id)).queue_free()
	
remote func GiveAdmin():
	var start_game_button_scene = preload("res://lobby/StartGame.tscn")
	var start_button = start_game_button_scene.instance()
	get_node("/root/Lobby").add_child(start_button)
	
func RequestStartGame():
	rpc_id(1,"StartGame")
	
remote func StartGame(connected_players,player_data):
	GameData.game_started = true
	
	get_tree().change_scene("res://game/Game.tscn")
	yield(get_tree().create_timer(.5),"timeout")
	get_node("/root/Game").connected_players = connected_players
	get_node("/root/Game").player_data = player_data
	get_node("/root/Game").init_players()

remote func UpdateNodeById(my_id,data):
	var server_nodes = get_tree().get_nodes_in_group("server")
	for node in server_nodes:
		if node.my_id == my_id:
			for key in data:
				node.set(key,data[key])
