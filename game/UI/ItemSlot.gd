extends TextureRect

signal slot_item_picked

var pickable setget set_pickable
var mouse_over = false
var type

func set_pickable(value):
	pickable = value

	if !pickable:
		rect_scale = Vector2(1,1)
		mouse_over = false

func _input(event):
	if !mouse_over or !pickable:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("slot_item_picked",self)

func update():
	var rect = Rect2(Vector2.ZERO,rect_size)
	if rect.has_point(get_local_mouse_position()):
		self.pickable = true
		_on_ItemSlot_mouse_entered()
	
func _on_ItemSlot_mouse_entered():
	#print(self.type)
	if !pickable:
		return
	mouse_over = true
	rect_scale = Vector2(1.1,1.1)

func _on_ItemSlot_mouse_exited():
	if !pickable:
		return
	mouse_over = false
	rect_scale = Vector2(1,1)
