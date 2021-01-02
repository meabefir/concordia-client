extends Control

var deck = [] setget set_deck
var nodes_deck = []
var tween_speed = .2

func set_deck(value):
	deck = value
	
	for child in get_children():
		child.queue_free()

	nodes_deck = []
	for i in range(deck.size()):
		var card = deck[i]
		var new_card = GameData.packed_scenes["Card"].instance()
		new_card.texture = GameData.card_textures[card]
		new_card.type = card
		new_card.rect_position.x = i*min(new_card.rect_min_size.x,rect_size.x/deck.size())
		add_child(new_card)
		nodes_deck.append(new_card)
	
	bring_cards_together()

func push_cards_from(middle_card):
		
	var space_for_one = middle_card.rect_size.x

	var total_space = rect_size.x
	var left = [] 
	var right = []
	var passed = false

	var pos = nodes_deck.find(middle_card)
	var middle_card_start = pos*rect_size.x/deck.size()
	for card in get_children():
		if card == middle_card:
			passed = true
			continue
		if !passed:
			left.append(card)
		else:
			right.append(card)
	var left_space = middle_card_start
	#var left_space = middle_card_start#-space_for_one/2
	var right_space = rect_size.x - (left_space+space_for_one)
	var space_for_one_left = left_space/max(left.size(),1)
	var space_for_one_right = right_space/max(right.size(),1)
	var start_right = left_space+space_for_one
	#var start_right = left_space+space_for_one

	for i in range(left.size()):
		var card = left[i]
		var future_pos = i*space_for_one_left
		card.get_node("Tween").stop_all()
		card.get_node("Tween").interpolate_property(card,"rect_position",card.rect_position,Vector2(future_pos,card.rect_position.y),tween_speed)
		card.get_node("Tween").start()

	for i in range(right.size()):
		var card = right[i]
		var future_pos = start_right+i*space_for_one_right
		card.get_node("Tween").stop_all()
		card.get_node("Tween").interpolate_property(card,"rect_position",card.rect_position,Vector2(future_pos,card.rect_position.y),tween_speed)
		card.get_node("Tween").start()
	
func bring_cards_together():
	for i in range(nodes_deck.size()):
		var card = nodes_deck[i]
		var future_pos = i*rect_size.x/nodes_deck.size()
		card.get_node("Tween").stop_all()
		card.get_node("Tween").interpolate_property(card,"rect_position",card.rect_position,Vector2(future_pos,card.rect_position.y),tween_speed)
		card.get_node("Tween").start()
