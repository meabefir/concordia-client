extends Control

signal item_picked

var type setget set_type
var mouse_over = false

func set_type(value):
	type = value
	
	get_node("TextureRect").texture = GameData.textures[type+"Item"]

func _input(event):
	if !mouse_over:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("item_picked",self)

func _on_TextureRect_mouse_entered():
	mouse_over = true
	rect_scale = Vector2(1.1,1.1)


func _on_TextureRect_mouse_exited():
	mouse_over = false
	rect_scale = Vector2(1,1)
