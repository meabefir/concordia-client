extends Node2D

signal region_picked

onready var game = get_node("/root/Game")
onready var resource_yield_tooltip_scene = preload("res://game/UI/ResourceYieldTooltip.tscn")
onready var collision = get_node("Area2D/CollisionPolygon2D")

var player
var my_id
var points
var index
#var highlighted = true setget set_highlighted
var color = Color(1,1,1,0)
var pickable = false setget set_pickable
var nodes = []
var type
var active = true setget set_active
# dumb as fuck name
var region_resource_yield setget yield_region_resource_yield

func set_pickable(value):
	pickable = value
	get_node("Area2D").input_pickable = pickable
	if pickable:
		collision.disabled = false
	else:
		collision.disabled = true
		delete_existing_tooltip()

func yield_all_resources():
	var resource_to_give = get_region_yield()
	
	player.add_to_inventory(resource_to_give)
	#for resource in resource_to_give:
	
	var data = {
		"region_resource_yield": null
	}
	Server.rpc_id(1,"UpdateNodeById",my_id,data)
		
func yield_region_resource_yield(val = null):
	var resource_to_give = get_region_resource_yield()
	
	player.add_to_inventory(resource_to_give)

func get_region_yield():
	return get_region_bonus_yield() + get_region_resource_yield()
		
func get_region_bonus_yield():
	var resource_to_give = []
	resource_to_give.append(type)
	if player.has_prefectus:
		resource_to_give.append(type)
		
	return resource_to_give
	
func get_region_resource_yield(val=null):
	var resource_to_give = []
	for node in nodes:
		if node in player.houses_on_nodes:
			resource_to_give.append(node.city_card.type)
			
	return resource_to_give
#func set_highlighted(value):
#	highlighted = value
#
#	if highlighted:
#		collision.disabled = false
#	else:
#		collision.disabled = true
		
func set_active(value):
	active = value
	
	var token = get_node("RegionToken")
	var token_sprite = get_node("RegionToken/Sprite")
	if !active:
		token_sprite.texture = GameData.textures[str(token.value)+"money"]
	else:
		token_sprite.texture = GameData.textures[token.type+"Token"]
		
func set_active_once(value):
	self.active = value
		
	var data = {
		"active": active
	}
	Server.rpc_id(1,'UpdateNodeById',my_id,data)
	
		
func _ready():
	calc_region_type()
		
func calc_region_type():
	var dic = {}
	for node in nodes:
		var node_type = node.city_type
		if node_type in dic:
			dic[node_type] += GameData.costs[node_type]
		else:
			dic[node_type] = GameData.costs[node_type]
			
	var maxim = 0
	for key in dic:
		if dic[key] > maxim:
			maxim = dic[key]
			type = key
	
	create_region_token()
		
func create_region_token():
	var new_region_token = GameData.packed_scenes["RegionToken"].instance()
	new_region_token.type = type
	new_region_token.get_node("Sprite").texture = GameData.textures[type+"Token"]
	new_region_token.global_position = GameData.region_tokens_pos[index]
	new_region_token.value = GameData.tokens_value[type]
	add_child(new_region_token)
		
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
	
	var new_resource_yield_tooltip = resource_yield_tooltip_scene.instance()
	new_resource_yield_tooltip.resources = get_region_yield()
	new_resource_yield_tooltip.region = self
	player.get_node("CanvasLayer/ResourceYieldTooltips").add_child(new_resource_yield_tooltip)

func _on_Area2D_mouse_exited():
	color.a = 0

	delete_existing_tooltip()
	
func delete_existing_tooltip():
	for tooltip in player.get_node("CanvasLayer/ResourceYieldTooltips").get_children():
		if tooltip.region == self:
			tooltip.queue_free()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("region_picked",self)
