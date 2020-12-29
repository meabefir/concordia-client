extends Node2D

signal build_picked

onready var game = get_node("/root/Game")
onready var collision = get_node("Area2D/CollisionPolygon2D")

var type = null setget set_type
var pickable = false setget set_pickable

func _ready():
	self.pickable = false
		
func set_pickable(value):
	pickable = value
	get_node("Area2D").input_pickable = pickable
	
	if pickable:
		collision.disabled = false
		$AnimatedSprite.get("material").set_shader_param("width",16)
	else:
		collision.disabled = true
		$AnimatedSprite.get("material").set_shader_param("width",0)

func set_type(value):
	type = value
	
	$AnimatedSprite.play(type)

func _on_Area2D_mouse_entered():
	scale = Vector2(.4,.4)

	# create cost tooltip
	var player = game.connected_players_nodes[game.turn]
	var new_cost_tooltip = GameData.packed_scenes["CostTooltip"].instance()
	new_cost_tooltip.node = self
	player.get_node("CanvasLayer").add_child(new_cost_tooltip)

func _on_Area2D_mouse_exited():
	scale = Vector2(.35,.35)

	var player = game.connected_players_nodes[game.turn]
	if player.has_node("CanvasLayer/CostTooltip"):
		player.get_node("CanvasLayer/CostTooltip").queue_free()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("build_picked",get_parent())
