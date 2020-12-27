extends Node2D

var owned_by = null

func _ready():
	print("picking colo")
	owned_by = get_node("../../")
	
	for colonist in owned_by.get_node("Colonists").get_children():
		colonist.connect("colonist_picked",self,"colonist_picked")

func colonist_picked(colonist):
	get_parent().colonist_picked = colonist
	queue_free()
