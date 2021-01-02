extends CanvasLayer

onready var game = get_node("/root/Game")
onready var player = get_node('../../')

func _ready():
	player.delete_turn_over_button()
	get_node("CoinsButton").text = "Collect "+str(5+game.my_player.get_node("Colonists").get_child_count())+" coins"
	
	if !game.my_player.inventory.has("FoodItem") or !game.my_player.inventory.has("AnvilItem"):
		get_node("ColonistsButton").queue_free()
	if game.my_player.house_nr == 0:
		get_node("ColonistsButton").queue_free()
	if game.my_player.colonists_added.size() == 2:
		get_node("ColonistsButton").queue_free()

func _on_ColonistsButton_pressed():
	get_parent().place_colonists_picked()
	queue_free()

func _on_CoinsButton_pressed():
	get_parent().collect_coins_picked()
	queue_free()
