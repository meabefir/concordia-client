extends CanvasLayer

onready var game = get_node("/root/Game")

func _ready():
	get_node("Control/Label/LandColonist").modulate = game.my_player.color
	get_node("Control/Label/WaterColonist").modulate = game.my_player.color

	var node_picked = get_parent().node_picked
	#(node_picked.id)
	if node_picked.water_connections.size() == 0:
		get_node("Control/Label/WaterColonist").queue_free()

	if "land" in game.my_player.colonists_added:
		get_node("Control/Label/LandColonist").queue_free()
	if "water" in game.my_player.colonists_added:
		get_node("Control/Label/WaterColonist").queue_free()

func _on_LandColonist_pressed():
	get_parent().colonist_type_picked("land")
	queue_free()
	
func _on_WaterColonist_pressed():
	get_parent().colonist_type_picked("water")
	queue_free()

func _on_LandColonist_mouse_entered():
	get_node("Control/Label/LandColonist").rect_scale = Vector2(2.1,2.1)

func _on_LandColonist_mouse_exited():
	get_node("Control/Label/LandColonist").rect_scale = Vector2(2,2)

func _on_WaterColonist_mouse_entered():
	get_node("Control/Label/WaterColonist").rect_scale = Vector2(2.1,2.1)

func _on_WaterColonist_mouse_exited():
	get_node("Control/Label/WaterColonist").rect_scale = Vector2(2,2)
