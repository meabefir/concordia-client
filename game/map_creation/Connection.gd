extends Node2D

signal picked_connection

var my_id
var cost = 0 setget set_cost
var type = 0
var node1 = null
var node2 = null
var between_nodes = null
var path = null
var points = null
var color = null
var curve = null

var highlighted = false setget set_highlight
var occupied = false

func set_cost(value):
	cost = value

func set_highlight(value):
	highlighted = value
	
	if highlighted:
		$Area2D/CollisionPolygon2D.disabled = false
	else:
		$Area2D/CollisionPolygon2D.disabled = true

func _draw():
	if !highlighted:
		return
	
	if path != null and typeof(points) == TYPE_VECTOR2_ARRAY:
		draw_polygon(points, PoolColorArray([color]))

func _process(delta):
	update()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT and !Helper.mouse_stopped:
		print("picked connection "+ str(self))
		emit_signal("picked_connection",self)
		Helper.set_mouse_stopped(true)

func mouse_enter():
	color.a = 1
	
func mouse_exit():
	color.a = .4

func create_collision():
	var collision = $Area2D/CollisionPolygon2D
	collision.disabled = true
	var area2d = $Area2D
	area2d.connect("input_event",self,"_on_Area2D_input_event")
	area2d.connect("mouse_entered",self,"mouse_enter")
	area2d.connect("mouse_exited",self,"mouse_exit")
	
	color = Color(  0.55, 0.27, 0.07, .5) if type == 1 else Color(0,0,1,.5)
	
	var width = 8
	points = []
	var points2 = []
	
	points.append(path[0] + (path[1]-path[0]).clamped(1).rotated(PI)*width)
	
	for i in range(1,path.size()-1):
		var point = path[i]
		var left = path[i-1]
		var right = path[i+1]
		var line1 = point-left
		var line2 = right-point
		var temp = (line1+line2).normalized()
		temp = temp.rotated(PI/2)
		points.append(point+temp*width)
		temp = temp.rotated(-PI)
		points2.insert(0,point+temp*width)
	
	points.append(path[path.size()-1] + (path[path.size()-2]-path[path.size()-1]).clamped(1).rotated(PI)*width)
	points += points2
	
	points = PoolVector2Array(points)
	
	collision.set_polygon(points)


func create_curve():
	curve = Curve2D.new()
	for point in path:
		curve.add_point(point)
	$Path2D.set_curve(curve)
