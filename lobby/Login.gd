extends CanvasLayer

func _on_JoinButton_pressed():
	var input = $AddressField.text
	Server.ConnectToServer(input)

func _ready():
	randomize()
	Server.ConnectToServer($AddressField.text)
