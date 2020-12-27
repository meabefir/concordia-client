extends Control

var changed = false

var color = Color(1,1,1) setget set_color
var player_name = "NoName" setget set_name

func _on_NameChangeButton_pressed():
	if changed and $NameField.text != "":
		self.player_name = $NameField.text
	else:
		self.player_name = player_name
	$NameChangeButton.queue_free()
	$NameField.queue_free()
	$ColorPickerButton.queue_free()
	$PickColor.queue_free()

func _on_NameField_focus_entered():
	if changed == false:
		changed = true
		$NameField.text = ""

func _ready():
	pass

func set_name(value):
	player_name = value
	
	$Name.text = value
	
	var data = {
		"player_name": player_name,
		"color": color
	}
	Server.rpc_id(1,"ServerUpdatePlayerData",data)

func set_color(value):
	color = value
	
	$Name.set("custom_colors/font_color",color)
	$PickColor.set("custom_colors/font_color",color)
	
func _on_ColorPickerButton_color_changed(color):
	set_color(color)
	
