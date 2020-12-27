extends Button



func _on_StartGame_pressed():
	Server.RequestStartGame()
