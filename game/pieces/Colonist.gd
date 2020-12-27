extends Node2D

var my_id
var owned_by = null
var between_nodes = null
var standing_on = null
var type = 0

signal colonist_picked

func _ready():
	self.modulate = owned_by.color

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT and !Helper.mouse_stopped:
		emit_signal("colonist_picked",self)
		Helper.set_mouse_stopped(true)
