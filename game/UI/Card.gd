extends TextureRect

signal picked_deck_card
var mouse_over = false
var pickable = false
var type

func _input(event):
	if !mouse_over or !pickable:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("picked_deck_card",self)

func _on_Card_mouse_entered():
	mouse_over = true
	rect_scale = Vector2(1.1,1.1)
	get_parent().push_cards_from(self)

func _on_Card_mouse_exited():
	mouse_over = false
	rect_scale = Vector2(1,1)
	get_parent().bring_cards_together()
