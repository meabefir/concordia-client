extends Control

var resources = [] setget set_resources
var region

func set_resources(value):
	resources = value

#	for item_container in get_node("VBoxContainer").get_children():
#		item_container.free()
#	get_node("Background").rect_min_size.y = 0
#	get_node("Background").rect_size.y = 0
#	get_node("VBoxContainer").rect_min_size.y = 0
#	get_node("VBoxContainer").rect_size.y = 0
	

	for resource in resources:
		var new_item_container = GameData.packed_scenes["ItemContainer"].instance()
		new_item_container.get_node("TextureRect").texture = GameData.textures[resource+"Item"]
		get_node("VBoxContainer").add_child(new_item_container)
		
		get_node("Background").rect_min_size.y += 80
		get_node("VBoxContainer").rect_min_size.y += 80
		
func _process(delta):
	rect_position = get_viewport().get_mouse_position()+Vector2(100,-get_node("Background").rect_min_size.y/2)
		
#func _ready():
#	var game = get_node("/root/Game")
#	var camera = game.get_node("Camera2D")
