extends Node2D

onready var player = get_node('../../')

var my_id
var node

func _ready():
	modulate = player.color
	visible = false
