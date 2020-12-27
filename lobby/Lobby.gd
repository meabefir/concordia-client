extends CanvasLayer

onready var lobby_player_scene = preload("res://lobby/LobbyPlayer.tscn")

func _ready():
	var lobby_player_instance = lobby_player_scene.instance()
	$PlayersContainer.add_child(lobby_player_instance)
	
