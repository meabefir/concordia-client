extends Node2D

onready var collision = get_node("Area2D/CollisionPolygon2D")

var points
#var highlighted = true setget set_highlighted
var color = Color(1,1,1,0)
var pickable = false setget set_pickable

#func set_highlighted(value):
#	highlighted = value
#
#	if highlighted:
#		collision.disabled = false
#	else:
#		collision.disabled = true
		
func _ready():
	self.pickable = false
		
func set_pickable(value):
	pickable = value
	get_node("Area2D").input_pickable = pickable
	if pickable:
		collision.disabled = false
	else:
		collision.disabled = true
		
		
func _draw():
	draw_polygon(points, PoolColorArray([color]))

func _process(delta):
	update()

func create_collision(data):
	points = data
	
	data = PoolVector2Array(data)
	
	collision.set_polygon(data)

func _on_Area2D_mouse_entered():
	color.a = .5

func _on_Area2D_mouse_exited():
	color.a = 0
