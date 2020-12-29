extends Node

var id = 0
var mouse_stopped = false setget set_mouse_stopped

func int_vector(vector):
	var pos = vector
	return Vector2(int(pos.x),int(pos.y))

func set_mouse_stopped(value):
	mouse_stopped = value
	yield(get_tree().create_timer(.1),"timeout")
	mouse_stopped = !value

func get_next_id():
	id += 1
	return id
