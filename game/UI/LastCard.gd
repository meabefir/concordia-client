extends TextureRect

var card_type = null setget set_card

func set_card(value):
	card_type = value
	
	texture = GameData.card_textures[card_type]
