extends Node2D

signal card_picked

onready var collision = get_node("Area2D/CollisionShape2D")

var index = null
var type = null
var pickable = false setget set_pickable
var resources = ["Brick","Food","Anvil","Wine","Silk"]
var cost = {}
var default_cost = {}

func _ready():
	self.pickable = false
	
	for resource in resources:
		if resource in type:
			cost[resource] = 1
			
	default_cost = cost.duplicate()
			
	if get_parent().extra_costs[index] != null:
		for e_cost in get_parent().extra_costs[index]:
			if e_cost in cost:
				cost[e_cost] += 1
			else:
				cost[e_cost] = 1
		
func set_pickable(value):
	pickable = value
	get_node("Area2D").input_pickable = pickable
	
	if pickable:
		collision.disabled = false
	else:
		collision.disabled = true


func _on_Area2D_mouse_entered():
	scale = Vector2(.4,.4)

func _on_Area2D_mouse_exited():
	scale = Vector2(.34,.34)


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		emit_signal("card_picked",self)
