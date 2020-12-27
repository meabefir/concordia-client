extends Camera2D

var move = 30
var mouse_pressed = false

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				var old_mouse_pos = get_global_mouse_position()
				zoom = zoom.move_toward(Vector2(.5,.5),.1)
				position -= get_global_mouse_position()-old_mouse_pos
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom = zoom.move_toward(Vector2(1,1),.1)
			if event.button_index == BUTTON_LEFT:
				mouse_pressed = true
		else:
			if event.button_index == BUTTON_LEFT:
				mouse_pressed = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if mouse_pressed:
			position -= event.relative*zoom
			position.x = clamp(position.x,limit_left+get_viewport_rect().size.x/2*zoom.x,limit_right-get_viewport_rect().size.x/2*zoom.x)
			position.y = clamp(position.y,limit_top+get_viewport_rect().size.y/2*zoom.x,limit_bottom-get_viewport_rect().size.y/2*zoom.x)
