extends Control

var player_name = "NoName" setget set_name
var color = Color(1,1,1) setget set_color

func update_data(data):
	for key in data:
		set(key,data[key])

func set_name(value):
	player_name = value
	
	$Name.text = value

func set_color(value):
	color = value
	
	$Name.set("custom_colors/font_color",color)
