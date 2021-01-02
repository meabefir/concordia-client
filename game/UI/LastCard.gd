extends TextureRect

signal last_card_picked

var card_type = null setget set_card
var mouse_over = false
var pickable setget set_pickable

func set_pickable(value):
	pickable = value

	if !pickable:
		mouse_over = false
		modulate = Color(1,1,1,1)

func set_card(value):
	card_type = value
	
	if value == null:
		texture = null
	else:
		texture = GameData.card_textures[card_type]

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if pickable and mouse_over:
			emit_signal("last_card_picked",card_type)

func _on_LastCard_mouse_entered():
	if !pickable:
		return
	mouse_over = true
	modulate = Color(0,1,0,0.5)

func _on_LastCard_mouse_exited():
	if !pickable:
		return
	mouse_over = false
	modulate = Color(1,1,1,1)
