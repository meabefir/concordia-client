extends Area2D

signal money_grabbed

onready var collision = get_node("CollisionShape2D")

var points = []
var pickable = false setget set_pickable
var color = Color(1,1,1,0)

func set_pickable(value):
	pickable = value
	input_pickable = pickable
	if pickable:
		collision.disabled = false
	else:
		collision.disabled = true

func _draw():
	draw_polygon(points, PoolColorArray([color]))

func _process(delta):
	update()

func _ready():
	self.pickable = false
	
	points.append(collision.global_position-collision.shape.extents)
	points.append(collision.global_position+Vector2(collision.shape.extents.x*2,0)-collision.shape.extents)
	points.append(collision.global_position+collision.shape.extents*2-collision.shape.extents)
	points.append(collision.global_position+Vector2(0,collision.shape.extents.y*2)-collision.shape.extents)

func _on_MoneyGrabRegion_mouse_entered():
	color.a = .5
	
func _on_MoneyGrabRegion_mouse_exited():
	color.a = 0

func _on_MoneyGrabRegion_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("money_grabbed")
