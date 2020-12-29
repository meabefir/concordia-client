extends Node

var game_started = false

var packed_scenes = {
	"MapNode": preload("res://game/map_creation/MapNode.tscn"),
	"CityCard": preload("res://game/map_creation/CityCard.tscn"),
	"Region": preload("res://game/map_creation/Region.tscn"),
	"Connection": preload("res://game/map_creation/Connection.tscn"),
	"LandColonist": preload("res://game/pieces/LandColonist.tscn"),
	"WaterColonist": preload("res://game/pieces/WaterColonist.tscn"),
	"House": preload("res://game/pieces/House.tscn"),
	"Player": preload("res://game/Player.tscn"),
	"PlayerTemplate": preload("res://game/PlayerTemplate.tscn"),
	"TurnOver": preload("res://game/card_actions/TurnOver.tscn"),
	"CostTooltip": preload("res://game/card_actions/architect/CostTooltip.tscn"),
	"BuyCard": preload("res://game/map_creation/BuyCard.tscn"),
	"Card": preload("res://game/UI/Card.tscn"),
	"ItemContainer": preload("res://game/UI/ItemContainer.tscn"),
	"RegionToken": preload("res://game/map_creation/RegionToken.tscn"),
	"CardPickAction": preload("res://game/card_actions/CardPick.tscn"),
	"ArchitectAction": preload("res://game/card_actions/architect/ArchitectAction.tscn"),
	"PrefectAction": preload("res://game/card_actions/prefect/PrefectAction.tscn"),
	"ItemOverflow": preload("res://game/UI/ItemOverflow.tscn"),
	"MercatorAction": preload("res://game/card_actions/mercator/MercatorAction.tscn"),
	"ShopWindow": preload("res://game/UI/ShopWindow.tscn")
}

var textures = {
	"BrickItem": preload("res://assets/resource_items/res bricc.png"),
	"FoodItem": preload("res://assets/resource_items/res wit.png"),
	"AnvilItem": preload("res://assets/resource_items/res iron.png"),
	"WineItem": preload("res://assets/resource_items/res whine.png"),
	"SilkItem": preload("res://assets/resource_items/res cloth.png"),
	"LandColonistItem": preload("res://assets/pieces/land_colonist.png"),
	"WaterColonistItem": preload("res://assets/pieces/water_colonist.png"),
	"BrickToken": preload("res://assets/region_tokens/region_token_brick.png"),
	"FoodToken": preload("res://assets/region_tokens/region_token_food.png"),
	"AnvilToken": preload("res://assets/region_tokens/region_token_anvil.png"),
	"WineToken": preload("res://assets/region_tokens/region_token_wine.png"),
	"SilkToken": preload("res://assets/region_tokens/region_token_silkl.png"),
	"2money": preload("res://assets/money/2money.png"),
	"1money": preload("res://assets/money/1money.png")
}

var card_textures = {
	"ArcJup": preload("res://assets/starting cards/architect.png"),
	"DipJup": preload("res://assets/starting cards/diplomat.png"),
	"MerMer": preload("res://assets/starting cards/mercator.png"),
	"PreSat": preload("res://assets/starting cards/prefect.png"),
	"SenVes": preload("res://assets/starting cards/senator.png"),
	"TriMar": preload("res://assets/starting cards/tribune.png"),
	"ArcJupAnvil": preload("res://assets/buy cards/architect 1.png"),
	"ColMarFood": preload("res://assets/buy cards/colonist 1.png"),
	"ConJupSilk": preload("res://assets/buy cards/consul 2.png"),
	"DipSatAnvil": preload("res://assets/buy cards/diplomat 1.png"),
	"DipSatFood": preload("res://assets/buy cards/diplomat 3.png"),
	"DipMerAnvil": preload("res://assets/buy cards/diplomat 4.png"),
	"DipMarFood": preload("res://assets/buy cards/diplomat 5.png"),
	"FarMinBrickFood": preload("res://assets/buy cards/farmer 1.png"),
	"MasMinFood": preload("res://assets/buy cards/mason 1.png"),
	"MerMerWine": preload("res://assets/buy cards/mercator 1.png"),
	"PreSatWine": preload("res://assets/buy cards/prefect 1.png"),
	"SmiMinBrickAnvil": preload("res://assets/buy cards/smith 1.png"),
	"VinMinBrickWine": preload("res://assets/buy cards/vintner 2.png"),
	"WeaMinBrickSilk": preload("res://assets/buy cards/weaver 2.png")
}

var starting_deck = ["ArcJup","DipJup","MerMer","MerMerWine","PreSat","PreSat","SenVes","TriMar","PreSat","PreSat","PreSat","PreSat","PreSat","PreSat","PreSat",]

var buy_cards_data = [
	["ArcJupAnvil","PreSatWine","MerMerWine","ColMarFood","DipSatAnvil","MasMinFood","FarMinBrickFood","SmiMinBrickAnvil"],
	["ArcJupAnvil","PreSatWine","MerMerWine","ColMarFood","ConJupSilk","VinMinBrickWine","WeaMinBrickSilk"],
	["ArcJupAnvil","PreSatWine","MerMerWine","ColMarFood","DipSatFood","ConJupSilk"],
	["ArcJupAnvil","PreSatWine","ColMarFood","DipMerAnvil","ConJupSilk"],
	["PreSatWine","MerMerWine","DipMarFood","ConJupSilk"]
]

var start_inventory = ["LandColonistItem","WaterColonistItem",
						"FoodItem","FoodItem","BrickItem","AnvilItem","WineItem","SilkItem"]

var costs = {
	"Brick": 3,
	"Food": 4,
	"Anvil": 5,
	"Wine": 6,
	"Silk": 7
}

var region_tokens_pos = [
Vector2(653,97),Vector2(653,38),Vector2(787,38),Vector2(789,96),Vector2(921,36),Vector2(924,97),Vector2(924,155),Vector2(789,155),Vector2(653,153),Vector2(518,155),Vector2(521,96),Vector2(521,36),
]

var tokens_value = {
	"Brick": 1,
	"Food": 2,
	"Anvil": 2,
	"Wine": 1,
	"Silk": 1
}

var house_costs = {
	"Brick":{"money":1,"materials":["FoodItem"]},
	"Food":{"money":2,"materials":["BrickItem","FoodItem"]},
	"Anvil":{"money":3,"materials":["BrickItem","AnvilItem"]},
	"Wine":{"money":4,"materials":["BrickItem","WineItem"]},
	"Silk":{"money":5,"materials":["BrickItem","SilkItem"]},
}

var city_cards = ["Brick","Brick","Brick","Brick","Brick","Brick","Brick","Brick",
					"Food","Food","Food","Food","Food","Food","Food",
					"Anvil","Anvil","Anvil","Anvil","Anvil","Anvil",
					"Wine","Wine","Wine","Wine","Wine",
					"Silk","Silk","Silk","Silk"]

var node_types = [0,'d','d','d','a','a','a','a','a','d','d','c','c','c','c','c','c','c','c','c','c','b','b','b','b','b','b','b','b','a','a']

var regions_data = [
	[Vector2(977,500),Vector2(972,477),Vector2(964,468),Vector2(972,442),Vector2(972,429),Vector2(987,406),Vector2(1000,396),Vector2(1016,392),Vector2(1026,379),Vector2(1060,381),Vector2(1077,364),Vector2(1099,353),Vector2(1127,353),Vector2(1146,356),Vector2(1160,353),Vector2(1169,364),Vector2(1195,372),Vector2(1214,372),Vector2(1219,392),Vector2(1191,423),Vector2(1165,400),Vector2(1142,392),Vector2(1114,400),Vector2(1123,454),Vector2(1160,470),Vector2(1179,509),Vector2(1214,523),Vector2(1234,519),Vector2(1233,534),Vector2(1253,541),Vector2(1302,566),Vector2(1302,584),Vector2(1273,565),Vector2(1257,571),Vector2(1257,588),Vector2(1279,611),Vector2(1267,624),Vector2(1257,645),Vector2(1244,699),Vector2(1164,684),Vector2(1164,666),Vector2(1225,653),Vector2(1248,616),Vector2(1233,584),Vector2(1169,549),Vector2(1108,519),Vector2(1064,475),Vector2(1023,466),Vector2(1003,489),Vector2(984,496),],
	[Vector2(829,264),Vector2(858,243),Vector2(856,231),Vector2(870,195),Vector2(881,195),Vector2(885,199),Vector2(901,193),Vector2(1434,193),Vector2(1416,220),Vector2(1399,230),Vector2(1381,216),Vector2(1366,201),Vector2(1307,201),Vector2(1280,235),Vector2(1247,261),Vector2(1224,268),Vector2(1215,293),Vector2(1204,307),Vector2(1197,316),Vector2(1211,331),Vector2(1212,346),Vector2(1189,342),Vector2(1159,323),Vector2(1134,327),Vector2(1092,326),Vector2(1065,339),Vector2(1048,354),Vector2(1023,353),Vector2(1009,358),Vector2(998,372),Vector2(985,385),Vector2(966,387),Vector2(948,373),Vector2(948,354),Vector2(939,330),Vector2(929,310),Vector2(897,289),Vector2(879,272),Vector2(848,266),],
	[Vector2(1212,441),Vector2(1247,403),Vector2(1243,382),Vector2(1232,363),Vector2(1238,341),Vector2(1223,317),Vector2(1242,286),Vector2(1262,280),Vector2(1274,267),Vector2(1289,253),Vector2(1312,234),Vector2(1347,220),Vector2(1374,249),Vector2(1407,259),Vector2(1435,234),Vector2(1453,194),Vector2(1656,194),Vector2(1671,231),Vector2(1648,264),Vector2(1664,291),Vector2(1687,286),Vector2(1694,302),Vector2(1669,305),Vector2(1638,341),Vector2(1622,314),Vector2(1591,313),Vector2(1618,276),Vector2(1573,277),Vector2(1579,267),Vector2(1546,275),Vector2(1526,308),Vector2(1533,330),Vector2(1514,349),Vector2(1506,381),Vector2(1496,414),Vector2(1446,436),Vector2(1400,449),Vector2(1361,445),Vector2(1330,437),Vector2(1288,441),Vector2(1273,464),Vector2(1220,442),],
	[Vector2(1288,475),Vector2(1299,461),Vector2(1334,460),Vector2(1357,468),Vector2(1389,472),Vector2(1418,473),Vector2(1445,460),Vector2(1453,495),Vector2(1416,507),Vector2(1403,530),Vector2(1416,565),Vector2(1462,592),Vector2(1437,625),Vector2(1450,671),Vector2(1407,671),Vector2(1380,633),Vector2(1395,619),Vector2(1366,606),Vector2(1334,565),Vector2(1320,529),Vector2(1319,506),Vector2(1292,475),],
	[Vector2(1468,450),Vector2(1506,436),Vector2(1529,461),Vector2(1582,465),Vector2(1620,465),Vector2(1668,424),Vector2(1721,413),Vector2(1737,423),Vector2(1774,431),Vector2(1800,413),Vector2(1817,417),Vector2(1850,390),Vector2(1848,363),Vector2(1820,340),Vector2(1783,327),Vector2(1721,293),Vector2(1721,279),Vector2(1735,252),Vector2(1724,233),Vector2(1747,210),Vector2(1697,231),Vector2(1685,193),Vector2(1896,193),Vector2(1898,497),Vector2(1858,515),Vector2(1794,528),Vector2(1751,555),Vector2(1739,585),Vector2(1740,604),Vector2(1721,616),Vector2(1706,619),Vector2(1678,603),Vector2(1648,612),Vector2(1616,639),Vector2(1599,622),Vector2(1582,622),Vector2(1564,616),Vector2(1547,603),Vector2(1544,588),Vector2(1518,585),Vector2(1518,576),Vector2(1533,558),Vector2(1524,543),Vector2(1506,547),Vector2(1503,528),Vector2(1526,516),Vector2(1563,496),Vector2(1532,489),Vector2(1509,505),Vector2(1475,497),Vector2(1467,463),],
	[Vector2(1762,585),Vector2(1770,570),Vector2(1798,557),Vector2(1821,547),Vector2(1858,543),Vector2(1896,532),Vector2(1894,799),Vector2(1862,788),Vector2(1827,791),Vector2(1797,787),Vector2(1800,754),Vector2(1794,739),Vector2(1812,707),Vector2(1813,677),Vector2(1812,647),Vector2(1813,608),Vector2(1817,584),Vector2(1789,597),Vector2(1767,592),],
	[Vector2(1560,860),Vector2(1590,841),Vector2(1624,847),Vector2(1645,849),Vector2(1671,820),Vector2(1698,809),Vector2(1717,806),Vector2(1729,818),Vector2(1775,809),Vector2(1804,817),Vector2(1840,818),Vector2(1896,826),Vector2(1898,939),Vector2(1863,935),Vector2(1848,914),Vector2(1821,910),Vector2(1813,921),Vector2(1752,860),Vector2(1744,870),Vector2(1797,928),Vector2(1789,941),Vector2(1556,939),Vector2(1563,916),Vector2(1560,893),Vector2(1559,868),],
	[Vector2(1146,841),Vector2(1173,855),Vector2(1202,864),Vector2(1227,856),Vector2(1256,863),Vector2(1284,898),Vector2(1330,905),Vector2(1380,918),Vector2(1398,891),Vector2(1384,866),Vector2(1403,837),Vector2(1441,810),Vector2(1482,818),Vector2(1482,829),Vector2(1514,840),Vector2(1544,833),Vector2(1537,875),Vector2(1532,902),Vector2(1533,941),Vector2(1122,941),Vector2(1119,914),Vector2(1133,886),Vector2(1134,859),],
	[Vector2(705,824),Vector2(739,837),Vector2(792,828),Vector2(815,810),Vector2(828,801),Vector2(842,803),Vector2(853,783),Vector2(889,771),Vector2(947,759),Vector2(980,757),Vector2(989,760),Vector2(1007,745),Vector2(1045,734),Vector2(1076,722),Vector2(1100,711),Vector2(1119,717),Vector2(1123,748),Vector2(1146,764),Vector2(1145,790),Vector2(1129,806),Vector2(1131,829),Vector2(1118,868),Vector2(1100,901),Vector2(1100,939),Vector2(604,941),Vector2(616,918),Vector2(644,895),Vector2(665,883),Vector2(686,837),],
	[Vector2(598,544),Vector2(640,546),Vector2(667,538),Vector2(696,546),Vector2(738,537),Vector2(763,556),Vector2(796,564),Vector2(820,561),Vector2(849,564),Vector2(895,561),Vector2(897,580),Vector2(874,602),Vector2(855,610),Vector2(851,629),Vector2(830,656),Vector2(828,682),Vector2(835,705),Vector2(823,721),Vector2(820,740),Vector2(797,748),Vector2(788,772),Vector2(751,780),Vector2(727,783),Vector2(701,794),Vector2(674,799),Vector2(658,768),Vector2(636,768),Vector2(604,772),Vector2(604,744),Vector2(589,722),Vector2(592,680),Vector2(598,642),Vector2(589,611),Vector2(589,594),Vector2(575,571),Vector2(578,549),],
	[Vector2(663,383),Vector2(700,362),Vector2(715,376),Vector2(750,364),Vector2(731,330),Vector2(742,323),Vector2(751,335),Vector2(784,335),Vector2(777,319),Vector2(805,304),Vector2(812,277),Vector2(830,287),Vector2(853,291),Vector2(870,295),Vector2(876,307),Vector2(892,319),Vector2(912,323),Vector2(920,339),Vector2(927,353),Vector2(926,369),Vector2(926,387),Vector2(939,399),Vector2(958,410),Vector2(947,429),Vector2(947,446),Vector2(941,464),Vector2(943,480),Vector2(958,498),Vector2(962,518),Vector2(931,518),Vector2(904,514),Vector2(892,518),Vector2(888,537),Vector2(855,538),Vector2(819,537),Vector2(774,529),Vector2(786,498),Vector2(766,468),Vector2(770,441),Vector2(747,437),Vector2(747,419),Vector2(731,408),Vector2(678,403),],
	[Vector2(535,193),Vector2(757,193),Vector2(754,207),Vector2(777,201),Vector2(797,208),Vector2(797,226),Vector2(782,239),Vector2(800,253),Vector2(800,272),Vector2(780,285),Vector2(743,272),Vector2(739,289),Vector2(738,299),Vector2(720,293),Vector2(705,303),Vector2(692,295),Vector2(669,310),Vector2(654,327),Vector2(631,335),Vector2(636,312),Vector2(655,294),Vector2(690,275),Vector2(655,279),Vector2(650,271),Vector2(635,279),Vector2(628,267),Vector2(658,244),Vector2(635,224),Vector2(639,213),Vector2(654,217),Vector2(670,208),Vector2(665,198),Vector2(621,197),Vector2(621,229),Vector2(619,247),Vector2(604,247),Vector2(589,273),Vector2(548,302),Vector2(529,282),Vector2(536,258),Vector2(552,244),Vector2(535,229),Vector2(529,208),],

]

var region_nodes = [
	[1,2,3],
	[4,5],
	[6,7,8],
	[9,10],
	[11,12,13],
	[14,15],
	[16,17,18],
	[19,20],
	[21,22],
	[23,24,25],
	[26,27,28],
	[29,30]
]

var nodes_coords = [Vector2(1143,538),
					Vector2(1021,439),
					Vector2(1152,405),
					Vector2(1252,666),
					Vector2(952,258),
					Vector2(1166,284),
					Vector2(1316,386),
					Vector2(1398,290),
					Vector2(1507,369),
					Vector2(1332,528),
					Vector2(1471,621),
					Vector2(1574,481),
					Vector2(1747,432),
					Vector2(1654,618),
					Vector2(1826,616),
					Vector2(1801,746),
					Vector2(1838,871),
					Vector2(1733,913),
					Vector2(1654,820),
					Vector2(1439,835),
					Vector2(1246,873),
					Vector2(1107,731),
					Vector2(764,853),
					Vector2(600,710),
					Vector2(828,696),
					Vector2(600,547),
					Vector2(783,493),
					Vector2(937,529),
					Vector2(839,360),
					Vector2(672,316),
					Vector2(761,267)]

var connections = [
	[1,0,1],
	[1,0,2],
	[1,0,3],
	[2,0,3],
	[2,0,21],
	[2,0,27],
	[1,1,0],
	[1,1,2],
	[1,1,4],
	[1,1,27],
	[1,2,0],
	[1,2,1],
	[1,2,5],
	[1,2,6],
	[2,2,9],
	[1,3,0],
	[2,3,9],
	[2,3,10],
	[2,3,19],
	[2,3,20],
	[2,3,21],
	[2,3,0],
	[1,4,1],
	[1,4,5],
	[1,4,28],
	[2,4,30],
	[1,5,2],
	[1,5,4],
	[1,5,6],
	[1,6,2],
	[1,6,5],
	[1,6,7],
	[1,6,8],
	[1,6,9],
	[1,7,6],
	[1,7,8],
	[1,8,6],
	[1,8,7],
	[1,8,11],
	[2,8,11],
	[2,8,12],
	[1,9,6],
	[1,9,10],
	[1,9,11],
	[2,9,2],
	[2,9,3],
	[1,10,9],
	[2,10,11],
	[2,10,13],
	[2,10,18],
	[2,10,19],
	[2,10,3],
	[1,11,8],
	[1,11,9],
	[1,11,12],
	[1,11,13],
	[2,11,8],
	[2,11,10],
	[2,11,12],
	[1,12,11],
	[1,12,14],
	[2,12,8],
	[2,12,11],
	[1,13,11],
	[1,13,14],
	[2,13,10],
	[2,13,14],
	[2,13,18],
	[1,14,12],
	[1,14,13],
	[1,14,15],
	[2,14,13],
	[2,14,15],
	[1,15,14],
	[1,15,16],
	[1,15,18],
	[2,15,14],
	[2,15,18],
	[1,16,15],
	[1,16,17],
	[1,17,16],
	[1,17,18],
	[1,17,19],
	[1,18,15],
	[1,18,17],
	[1,18,19],
	[2,18,10],
	[2,18,13],
	[2,18,15],
	[2,18,19],
	[1,19,17],
	[1,19,18],
	[1,19,20],
	[2,19,3],
	[2,19,10],
	[2,19,18],
	[2,19,20],
	[1,20,19],
	[1,20,21],
	[2,20,3],
	[2,20,19],
	[2,20,21],
	[1,21,20],
	[1,21,22],
	[2,21,0],
	[2,21,3],
	[2,21,20],
	[2,21,22],
	[2,21,24],
	[2,21,27],
	[1,22,21],
	[1,22,23],
	[1,22,24],
	[2,22,21],
	[2,22,23],
	[2,22,24],
	[1,23,22],
	[1,23,24],
	[1,23,25],
	[2,23,22],
	[2,23,25],
	[1,24,22],
	[1,24,23],
	[1,24,25],
	[1,24,27],
	[2,24,21],
	[2,24,22],
	[2,24,27],
	[1,25,23],
	[1,25,24],
	[1,25,26],
	[2,25,23],
	[2,25,26],
	[2,25,29],
	[1,26,25],
	[1,26,27],
	[1,26,28],
	[2,26,25],
	[2,26,29],
	[1,27,1],
	[1,27,24],
	[1,27,26],
	[1,27,28],
	[2,27,0],
	[2,27,21],
	[2,27,24],
	[1,28,4],
	[1,28,26],
	[1,28,27],
	[1,28,30],
	[1,29,30],
	[2,29,25],
	[2,29,26],
	[2,29,30],
	[1,30,28],
	[1,30,29],
	[2,30,4],
	[2,30,29]	
]

var connection_paths = [
	[Vector2(1117,522),Vector2(1099,507),Vector2(1080,489),Vector2(1075,466),Vector2(1064,449),Vector2(1053,442),Vector2(1044,438),],
	[Vector2(1145,503),Vector2(1147,492),Vector2(1141,478),Vector2(1130,463),Vector2(1110,453),Vector2(1099,438),Vector2(1095,416),Vector2(1098,401),Vector2(1113,396),Vector2(1126,393),],
	[Vector2(1170,540),Vector2(1191,553),Vector2(1216,564),Vector2(1237,577),Vector2(1252,599),Vector2(1259,618),Vector2(1259,635),],
	[Vector2(1163,571),Vector2(1183,587),Vector2(1205,604),Vector2(1220,619),Vector2(1239,641),],
	[Vector2(1128,570),Vector2(1124,596),Vector2(1114,633),Vector2(1109,654),Vector2(1107,692),],
	[Vector2(1118,534),Vector2(1101,539),Vector2(1087,539),Vector2(1075,530),Vector2(1063,515),Vector2(1052,504),Vector2(1040,503),Vector2(1021,516),Vector2(999,531),Vector2(980,534),Vector2(963,530),],
	[Vector2(1045,438),Vector2(1063,447),Vector2(1072,458),Vector2(1078,474),Vector2(1083,489),Vector2(1101,503),Vector2(1113,516),Vector2(1122,522),],
	[Vector2(1030,407),Vector2(1044,392),Vector2(1063,385),Vector2(1091,380),Vector2(1117,380),Vector2(1130,382),],
	[Vector2(999,411),Vector2(990,393),Vector2(979,380),Vector2(968,366),Vector2(961,350),Vector2(961,327),Vector2(957,309),Vector2(949,286),],
	[Vector2(999,449),Vector2(986,465),Vector2(972,481),Vector2(957,503),],
	[Vector2(1127,394),Vector2(1109,394),Vector2(1098,402),Vector2(1094,420),Vector2(1101,439),Vector2(1113,456),Vector2(1128,466),Vector2(1142,475),Vector2(1147,486),Vector2(1146,502),],
	[Vector2(1127,382),Vector2(1096,382),Vector2(1067,383),Vector2(1044,393),Vector2(1031,406),],
	[Vector2(1169,378),Vector2(1181,362),Vector2(1182,347),Vector2(1182,332),Vector2(1178,313),],
	[Vector2(1177,391),Vector2(1200,393),Vector2(1227,393),Vector2(1259,393),Vector2(1288,387),],
	[Vector2(1161,433),Vector2(1173,451),Vector2(1190,471),Vector2(1213,489),Vector2(1246,498),Vector2(1278,504),Vector2(1297,508),Vector2(1307,516),],
	[Vector2(1259,632),Vector2(1259,613),Vector2(1246,589),Vector2(1227,567),Vector2(1197,554),Vector2(1169,540),],
	[Vector2(1280,650),Vector2(1293,642),Vector2(1307,624),Vector2(1315,596),Vector2(1315,577),Vector2(1315,539),],
	[Vector2(1278,671),Vector2(1297,671),Vector2(1328,682),Vector2(1376,694),Vector2(1412,697),Vector2(1443,694),Vector2(1454,682),Vector2(1461,659),Vector2(1458,632),],
	[Vector2(1270,681),Vector2(1289,705),Vector2(1308,727),Vector2(1334,751),Vector2(1365,770),Vector2(1388,786),Vector2(1416,812),],
	[Vector2(1255,681),Vector2(1265,709),Vector2(1270,728),Vector2(1266,761),Vector2(1257,788),Vector2(1247,815),Vector2(1243,835),],
	[Vector2(1228,651),Vector2(1201,648),Vector2(1177,646),Vector2(1159,658),Vector2(1142,671),Vector2(1128,686),Vector2(1117,697),],
	[Vector2(1239,639),Vector2(1223,619),Vector2(1201,601),Vector2(1184,589),Vector2(1167,578),Vector2(1159,562),],
	[Vector2(948,287),Vector2(956,305),Vector2(959,325),Vector2(959,341),Vector2(963,364),Vector2(979,379),Vector2(994,398),Vector2(1000,410),],
	[Vector2(975,251),Vector2(997,245),Vector2(1021,240),Vector2(1046,237),Vector2(1077,240),Vector2(1100,249),Vector2(1119,259),Vector2(1138,267),],
	[Vector2(936,272),Vector2(925,287),Vector2(910,309),Vector2(890,325),Vector2(875,337),Vector2(866,341),],
	[Vector2(935,233),Vector2(929,222),Vector2(916,221),Vector2(890,233),Vector2(867,236),Vector2(844,232),Vector2(821,232),Vector2(782,240),],
	[Vector2(1174,297),Vector2(1178,316),Vector2(1181,341),Vector2(1177,366),Vector2(1169,378),],
	[Vector2(1140,268),Vector2(1113,253),Vector2(1089,244),Vector2(1058,237),Vector2(1025,244),Vector2(1000,245),Vector2(977,247),],
	[Vector2(1192,282),Vector2(1209,287),Vector2(1232,293),Vector2(1239,302),Vector2(1243,329),Vector2(1251,355),Vector2(1257,368),Vector2(1277,379),Vector2(1289,379),],
	[Vector2(1293,391),Vector2(1277,394),Vector2(1250,397),Vector2(1216,393),Vector2(1200,393),Vector2(1181,391),],
	[Vector2(1292,379),Vector2(1270,378),Vector2(1259,370),Vector2(1251,352),Vector2(1246,328),Vector2(1239,306),Vector2(1232,293),Vector2(1213,287),Vector2(1192,282),],
	[Vector2(1315,352),Vector2(1312,332),Vector2(1316,314),Vector2(1323,299),Vector2(1338,287),Vector2(1358,282),Vector2(1376,279),],
	[Vector2(1339,393),Vector2(1358,408),Vector2(1385,417),Vector2(1415,421),Vector2(1445,416),Vector2(1466,405),Vector2(1487,383),],
	[Vector2(1316,398),Vector2(1319,424),Vector2(1323,448),Vector2(1324,474),Vector2(1330,494),],
	[Vector2(1374,279),Vector2(1347,285),Vector2(1324,299),Vector2(1315,329),Vector2(1315,355),],
	[Vector2(1424,282),Vector2(1450,288),Vector2(1470,302),Vector2(1484,322),Vector2(1493,343),],
	[Vector2(1489,380),Vector2(1473,400),Vector2(1449,415),Vector2(1422,421),Vector2(1392,417),Vector2(1366,410),Vector2(1343,396),],
	[Vector2(1491,342),Vector2(1485,325),Vector2(1473,308),Vector2(1450,288),Vector2(1424,283),],
	[Vector2(1496,380),Vector2(1491,396),Vector2(1489,419),Vector2(1487,442),Vector2(1495,457),Vector2(1516,463),Vector2(1539,469),Vector2(1549,472),],
	[Vector2(1514,384),Vector2(1514,406),Vector2(1519,430),Vector2(1530,444),Vector2(1550,456),],
	[Vector2(1531,364),Vector2(1553,364),Vector2(1583,364),Vector2(1615,368),Vector2(1656,373),Vector2(1696,380),Vector2(1725,391),Vector2(1741,402),],
	[Vector2(1326,494),Vector2(1326,467),Vector2(1320,444),Vector2(1320,421),Vector2(1316,400),],
	[Vector2(1335,552),Vector2(1347,564),Vector2(1362,580),Vector2(1384,594),Vector2(1411,605),Vector2(1431,609),Vector2(1447,609),],
	[Vector2(1343,499),Vector2(1357,488),Vector2(1374,479),Vector2(1393,475),Vector2(1417,479),Vector2(1439,480),Vector2(1464,479),Vector2(1489,484),Vector2(1522,486),Vector2(1546,479),],
	[Vector2(1308,515),Vector2(1285,506),Vector2(1261,506),Vector2(1232,494),Vector2(1204,483),Vector2(1190,469),Vector2(1177,452),Vector2(1159,434),Vector2(1147,417),],
	[Vector2(1315,536),Vector2(1312,552),Vector2(1315,580),Vector2(1311,613),Vector2(1300,633),Vector2(1280,651),],
	[Vector2(1449,609),Vector2(1422,607),Vector2(1389,595),Vector2(1369,582),Vector2(1347,563),Vector2(1333,538),],
	[Vector2(1480,591),Vector2(1481,571),Vector2(1487,545),Vector2(1496,530),Vector2(1507,522),Vector2(1516,513),Vector2(1531,515),Vector2(1542,503),Vector2(1554,490),],
	[Vector2(1499,613),Vector2(1508,621),Vector2(1518,633),Vector2(1542,645),Vector2(1562,653),Vector2(1577,649),Vector2(1591,640),Vector2(1606,648),Vector2(1629,660),Vector2(1650,663),Vector2(1656,644),Vector2(1660,628),],
	[Vector2(1491,636),Vector2(1499,659),Vector2(1512,679),Vector2(1531,690),Vector2(1564,695),Vector2(1583,717),Vector2(1599,737),Vector2(1614,759),Vector2(1627,779),Vector2(1638,793),],
	[Vector2(1476,628),Vector2(1476,656),Vector2(1477,679),Vector2(1470,690),Vector2(1461,695),Vector2(1453,710),Vector2(1443,740),Vector2(1438,760),Vector2(1435,786),Vector2(1434,801),],
	[Vector2(1458,632),Vector2(1461,660),Vector2(1457,682),Vector2(1447,694),Vector2(1435,697),Vector2(1407,695),Vector2(1366,691),Vector2(1338,683),Vector2(1312,674),Vector2(1292,668),Vector2(1278,668),],
	[Vector2(1550,472),Vector2(1527,467),Vector2(1504,457),Vector2(1491,449),Vector2(1487,433),Vector2(1491,411),Vector2(1496,380),],
	[Vector2(1545,480),Vector2(1527,483),Vector2(1500,483),Vector2(1473,480),Vector2(1450,480),Vector2(1420,476),Vector2(1393,475),Vector2(1376,476),Vector2(1358,486),Vector2(1346,499),],
	[Vector2(1596,475),Vector2(1615,480),Vector2(1637,476),Vector2(1654,467),Vector2(1665,457),Vector2(1684,442),Vector2(1710,433),Vector2(1725,433),],
	[Vector2(1572,492),Vector2(1583,517),Vector2(1592,544),Vector2(1602,571),Vector2(1615,594),Vector2(1633,599),],
	[Vector2(1550,456),Vector2(1530,447),Vector2(1518,433),Vector2(1516,412),Vector2(1514,383),],
	[Vector2(1558,486),Vector2(1545,493),Vector2(1539,509),Vector2(1516,512),Vector2(1500,529),Vector2(1489,535),Vector2(1481,558),Vector2(1484,585),Vector2(1476,593),],
	[Vector2(1587,455),Vector2(1602,447),Vector2(1615,443),Vector2(1633,428),Vector2(1645,414),Vector2(1661,402),Vector2(1680,401),Vector2(1707,402),Vector2(1725,408),],
	[Vector2(1723,431),Vector2(1706,433),Vector2(1683,443),Vector2(1669,460),Vector2(1646,474),Vector2(1619,478),Vector2(1596,475),],
	[Vector2(1761,444),Vector2(1772,474),Vector2(1780,497),Vector2(1792,524),Vector2(1813,555),Vector2(1826,586),],
	[Vector2(1744,401),Vector2(1726,391),Vector2(1696,382),Vector2(1660,371),Vector2(1608,364),Vector2(1573,364),Vector2(1542,362),Vector2(1530,362),],
	[Vector2(1725,406),Vector2(1702,401),Vector2(1673,401),Vector2(1650,412),Vector2(1637,424),Vector2(1625,435),Vector2(1610,444),Vector2(1587,455),],
	[Vector2(1633,601),Vector2(1618,593),Vector2(1602,566),Vector2(1591,540),Vector2(1579,517),Vector2(1573,493),],
	[Vector2(1680,609),Vector2(1695,608),Vector2(1719,604),Vector2(1752,594),Vector2(1772,581),Vector2(1792,578),Vector2(1817,589),],
	[Vector2(1657,627),Vector2(1656,642),Vector2(1652,655),Vector2(1641,663),Vector2(1625,662),Vector2(1611,650),Vector2(1599,644),Vector2(1587,640),Vector2(1572,648),Vector2(1550,648),Vector2(1530,642),Vector2(1514,631),Vector2(1508,619),Vector2(1496,616),],
	[Vector2(1668,627),Vector2(1683,640),Vector2(1706,650),Vector2(1730,651),Vector2(1756,640),Vector2(1780,628),Vector2(1802,619),],
	[Vector2(1664,627),Vector2(1675,655),Vector2(1679,682),Vector2(1679,709),Vector2(1673,734),Vector2(1669,761),Vector2(1664,784),],
	[Vector2(1826,585),Vector2(1819,566),Vector2(1806,548),Vector2(1788,521),Vector2(1779,497),Vector2(1769,467),Vector2(1756,443),],
	[Vector2(1817,586),Vector2(1798,577),Vector2(1780,577),Vector2(1769,585),Vector2(1749,594),Vector2(1719,605),Vector2(1695,609),Vector2(1680,609),],
	[Vector2(1826,635),Vector2(1833,655),Vector2(1838,677),Vector2(1833,697),Vector2(1819,723),],
	[Vector2(1799,621),Vector2(1775,631),Vector2(1753,639),Vector2(1737,648),Vector2(1719,654),Vector2(1698,650),Vector2(1680,640),Vector2(1672,627),],
	[Vector2(1803,628),Vector2(1794,640),Vector2(1792,658),Vector2(1792,678),Vector2(1798,701),Vector2(1802,715),],
	[Vector2(1821,723),Vector2(1833,705),Vector2(1839,685),Vector2(1836,667),Vector2(1831,650),Vector2(1825,631),],
	[Vector2(1812,757),Vector2(1827,777),Vector2(1838,793),Vector2(1845,811),Vector2(1845,828),Vector2(1843,835),],
	[Vector2(1807,761),Vector2(1801,786),Vector2(1796,803),Vector2(1785,816),Vector2(1770,823),Vector2(1749,826),Vector2(1726,830),Vector2(1692,830),Vector2(1674,824),],
	[Vector2(1801,715),Vector2(1792,694),Vector2(1789,673),Vector2(1793,651),Vector2(1801,636),Vector2(1811,624),],
	[Vector2(1776,740),Vector2(1761,750),Vector2(1747,766),Vector2(1732,784),Vector2(1715,793),Vector2(1696,800),Vector2(1682,807),],
	[Vector2(1842,839),Vector2(1847,816),Vector2(1843,796),Vector2(1830,780),Vector2(1812,759),],
	[Vector2(1815,858),Vector2(1796,855),Vector2(1765,851),Vector2(1746,851),Vector2(1738,855),Vector2(1732,866),Vector2(1734,880),],
	[Vector2(1732,876),Vector2(1732,862),Vector2(1742,853),Vector2(1765,851),Vector2(1788,851),Vector2(1811,857),],
	[Vector2(1711,892),Vector2(1700,874),Vector2(1701,858),Vector2(1693,842),Vector2(1673,830),],
	[Vector2(1709,915),Vector2(1682,926),Vector2(1654,927),Vector2(1620,926),Vector2(1571,922),Vector2(1521,908),Vector2(1475,895),Vector2(1450,876),Vector2(1439,866),Vector2(1432,847),],
	[Vector2(1678,824),Vector2(1707,830),Vector2(1739,826),Vector2(1766,826),Vector2(1789,812),Vector2(1801,793),Vector2(1807,766),],
	[Vector2(1680,834),Vector2(1692,839),Vector2(1700,853),Vector2(1700,865),Vector2(1700,876),Vector2(1707,888),Vector2(1715,895),],
	[Vector2(1655,830),Vector2(1657,847),Vector2(1646,855),Vector2(1615,857),Vector2(1571,857),Vector2(1536,847),Vector2(1494,839),Vector2(1466,834),],
	[Vector2(1636,796),Vector2(1624,778),Vector2(1609,751),Vector2(1588,724),Vector2(1567,704),Vector2(1544,688),Vector2(1525,686),Vector2(1512,681),Vector2(1498,663),Vector2(1482,635),],
	[Vector2(1663,786),Vector2(1670,763),Vector2(1674,734),Vector2(1680,705),Vector2(1677,677),Vector2(1674,662),Vector2(1663,631),],
	[Vector2(1680,807),Vector2(1696,801),Vector2(1720,792),Vector2(1734,782),Vector2(1749,765),Vector2(1758,751),Vector2(1766,746),Vector2(1776,738),],
	[Vector2(1631,803),Vector2(1604,797),Vector2(1574,792),Vector2(1540,788),Vector2(1501,786),Vector2(1478,789),Vector2(1458,797),Vector2(1450,803),],
	[Vector2(1432,846),Vector2(1439,869),Vector2(1467,895),Vector2(1525,908),Vector2(1581,924),Vector2(1651,930),Vector2(1692,926),Vector2(1711,915),],
	[Vector2(1466,835),Vector2(1501,846),Vector2(1548,853),Vector2(1588,858),Vector2(1627,858),Vector2(1650,855),Vector2(1659,846),Vector2(1659,832),],
	[Vector2(1424,843),Vector2(1413,869),Vector2(1406,889),Vector2(1401,912),Vector2(1389,927),Vector2(1379,931),Vector2(1363,931),Vector2(1343,927),Vector2(1320,922),Vector2(1298,915),Vector2(1270,904),Vector2(1256,892),],
	[Vector2(1417,809),Vector2(1394,793),Vector2(1366,777),Vector2(1340,761),Vector2(1316,738),Vector2(1298,715),Vector2(1285,700),Vector2(1270,686),],
	[Vector2(1432,800),Vector2(1435,770),Vector2(1440,742),Vector2(1447,723),Vector2(1455,704),Vector2(1471,688),Vector2(1478,671),Vector2(1477,650),Vector2(1473,635),],
	[Vector2(1452,803),Vector2(1467,792),Vector2(1494,786),Vector2(1532,788),Vector2(1571,793),Vector2(1605,800),Vector2(1628,803),],
	[Vector2(1413,820),Vector2(1385,812),Vector2(1354,812),Vector2(1328,811),Vector2(1302,811),Vector2(1283,820),Vector2(1268,832),Vector2(1259,842),],
	[Vector2(1255,880),Vector2(1264,897),Vector2(1289,912),Vector2(1312,918),Vector2(1329,922),Vector2(1352,927),Vector2(1375,931),Vector2(1389,927),Vector2(1397,918),Vector2(1406,895),Vector2(1413,870),Vector2(1424,846),],
	[Vector2(1222,872),Vector2(1195,872),Vector2(1164,869),Vector2(1140,857),Vector2(1124,846),Vector2(1114,824),Vector2(1109,797),Vector2(1107,773),Vector2(1105,742),],
	[Vector2(1243,838),Vector2(1248,816),Vector2(1259,793),Vector2(1266,766),Vector2(1271,738),Vector2(1266,715),Vector2(1262,696),Vector2(1256,681),],
	[Vector2(1259,842),Vector2(1270,830),Vector2(1287,816),Vector2(1316,812),Vector2(1351,811),Vector2(1381,816),Vector2(1413,823),],
	[Vector2(1222,855),Vector2(1202,842),Vector2(1182,823),Vector2(1164,801),Vector2(1160,777),Vector2(1156,747),Vector2(1156,734),Vector2(1151,727),Vector2(1141,723),Vector2(1132,720),],
	[Vector2(1107,743),Vector2(1107,765),Vector2(1113,789),Vector2(1118,826),Vector2(1132,851),Vector2(1153,862),Vector2(1183,870),Vector2(1205,872),Vector2(1220,874),],
	[Vector2(1083,736),Vector2(1059,750),Vector2(1007,766),Vector2(957,786),Vector2(913,801),Vector2(871,819),Vector2(842,828),Vector2(807,838),Vector2(788,842),],
	[Vector2(1105,696),Vector2(1109,674),Vector2(1113,648),Vector2(1118,623),Vector2(1126,600),Vector2(1128,581),Vector2(1132,566),],
	[Vector2(1114,700),Vector2(1132,681),Vector2(1147,665),Vector2(1159,655),Vector2(1172,650),Vector2(1199,650),Vector2(1218,650),Vector2(1225,654),],
	[Vector2(1133,719),Vector2(1147,724),Vector2(1156,734),Vector2(1159,763),Vector2(1160,782),Vector2(1168,803),Vector2(1182,820),Vector2(1202,842),Vector2(1222,851),],
	[Vector2(1082,717),Vector2(1057,715),Vector2(1036,719),Vector2(1018,728),Vector2(986,732),Vector2(957,742),Vector2(930,747),Vector2(907,750),Vector2(887,757),Vector2(865,770),Vector2(838,782),Vector2(807,800),Vector2(775,819),],
	[Vector2(1087,704),Vector2(1068,696),Vector2(1048,688),Vector2(1021,686),Vector2(990,692),Vector2(971,696),Vector2(949,700),Vector2(925,690),Vector2(911,674),Vector2(894,665),Vector2(879,665),Vector2(853,674),],
	[Vector2(1095,700),Vector2(1094,685),Vector2(1087,674),Vector2(1075,669),Vector2(1057,669),Vector2(1041,669),Vector2(1030,663),Vector2(1021,646),Vector2(1013,628),Vector2(1006,608),Vector2(994,594),Vector2(980,581),Vector2(968,563),Vector2(948,544),],
	[Vector2(788,842),Vector2(823,838),Vector2(861,823),Vector2(907,805),Vector2(945,789),Vector2(990,773),Vector2(1030,755),Vector2(1057,747),Vector2(1082,734),],
	[Vector2(737,851),Vector2(715,851),Vector2(696,849),Vector2(681,834),Vector2(676,801),Vector2(664,778),Vector2(653,765),Vector2(634,759),Vector2(614,747),Vector2(607,724),],
	[Vector2(742,838),Vector2(719,838),Vector2(691,826),Vector2(685,801),Vector2(691,784),Vector2(706,770),Vector2(727,761),Vector2(760,754),Vector2(783,742),Vector2(804,731),Vector2(819,717),Vector2(825,708),],
	[Vector2(777,819),Vector2(798,801),Vector2(830,788),Vector2(856,774),Vector2(879,761),Vector2(899,750),Vector2(938,742),Vector2(968,738),Vector2(1009,724),Vector2(1045,717),Vector2(1060,713),Vector2(1082,717),],
	[Vector2(741,830),Vector2(727,811),Vector2(704,809),Vector2(680,815),Vector2(641,819),Vector2(608,820),Vector2(576,811),Vector2(558,788),Vector2(547,766),Vector2(538,738),Vector2(538,724),Vector2(545,713),Vector2(558,705),Vector2(572,705),],
	[Vector2(752,819),Vector2(752,805),Vector2(761,796),Vector2(784,788),Vector2(802,782),Vector2(825,770),Vector2(848,757),Vector2(865,742),Vector2(876,728),Vector2(879,717),Vector2(879,704),Vector2(865,697),Vector2(856,696),],
	[Vector2(611,723),Vector2(616,740),Vector2(623,751),Vector2(639,763),Vector2(653,766),Vector2(665,778),Vector2(673,793),Vector2(680,815),Vector2(681,830),Vector2(687,843),Vector2(703,847),Vector2(727,849),Vector2(741,849),],
	[Vector2(623,711),Vector2(645,723),Vector2(683,727),Vector2(723,723),Vector2(754,715),Vector2(784,708),Vector2(802,700),],
	[Vector2(611,681),Vector2(614,651),Vector2(608,613),Vector2(603,589),Vector2(596,571),],
	[Vector2(573,704),Vector2(553,708),Vector2(538,723),Vector2(541,751),Vector2(553,780),Vector2(572,805),Vector2(608,823),Vector2(649,820),Vector2(692,812),Vector2(714,811),Vector2(723,811),Vector2(733,823),Vector2(738,830),],
	[Vector2(573,701),Vector2(561,688),Vector2(547,665),Vector2(539,642),Vector2(535,619),Vector2(538,593),Vector2(545,566),Vector2(558,552),Vector2(576,536),],
	[Vector2(819,711),Vector2(810,728),Vector2(791,740),Vector2(760,750),Vector2(731,761),Vector2(706,770),Vector2(692,786),Vector2(689,797),Vector2(689,812),Vector2(695,824),Vector2(704,834),Vector2(718,838),Vector2(741,839),],
	[Vector2(804,701),Vector2(787,711),Vector2(756,719),Vector2(704,728),Vector2(669,727),Vector2(639,720),Vector2(619,713),],
	[Vector2(811,669),Vector2(795,650),Vector2(775,631),Vector2(745,616),Vector2(714,604),Vector2(689,596),Vector2(668,590),Vector2(646,585),Vector2(627,570),Vector2(614,558),],
	[Vector2(823,663),Vector2(829,635),Vector2(848,612),Vector2(864,596),Vector2(880,578),Vector2(880,555),Vector2(880,536),Vector2(888,525),Vector2(902,520),Vector2(910,517),],
	[Vector2(853,677),Vector2(873,669),Vector2(890,665),Vector2(913,678),Vector2(929,692),Vector2(953,700),Vector2(972,694),Vector2(998,688),Vector2(1030,686),Vector2(1060,686),Vector2(1087,704),],
	[Vector2(856,696),Vector2(871,700),Vector2(880,709),Vector2(880,724),Vector2(869,738),Vector2(850,754),Vector2(837,763),Vector2(819,773),Vector2(798,782),Vector2(773,792),Vector2(758,797),Vector2(752,809),Vector2(752,820),],
	[Vector2(844,669),Vector2(865,655),Vector2(883,639),Vector2(896,619),Vector2(903,600),Vector2(911,581),Vector2(917,563),Vector2(926,536),],
	[Vector2(593,558),Vector2(599,571),Vector2(607,593),Vector2(612,623),Vector2(614,646),Vector2(611,677),],
	[Vector2(608,562),Vector2(631,575),Vector2(653,586),Vector2(683,590),Vector2(714,600),Vector2(742,613),Vector2(775,628),Vector2(796,644),Vector2(815,667),],
	[Vector2(622,555),Vector2(639,559),Vector2(676,559),Vector2(704,555),Vector2(733,550),Vector2(761,547),Vector2(784,536),Vector2(792,524),Vector2(796,508),],
	[Vector2(576,539),Vector2(562,550),Vector2(547,566),Vector2(535,598),Vector2(539,631),Vector2(547,662),Vector2(557,685),Vector2(570,697),],
	[Vector2(623,527),Vector2(641,527),Vector2(658,524),Vector2(681,520),Vector2(695,508),Vector2(715,498),Vector2(737,493),Vector2(758,486),],
	[Vector2(584,517),Vector2(577,485),Vector2(573,458),Vector2(573,424),Vector2(584,398),Vector2(596,382),Vector2(622,364),Vector2(641,347),Vector2(658,325),],
	[Vector2(795,508),Vector2(795,521),Vector2(787,535),Vector2(769,547),Vector2(729,554),Vector2(700,555),Vector2(673,559),Vector2(645,559),Vector2(614,555),],
	[Vector2(806,494),Vector2(834,498),Vector2(867,506),Vector2(913,508),],
	[Vector2(783,463),Vector2(784,443),Vector2(791,417),Vector2(796,397),Vector2(810,383),Vector2(829,371),],
	[Vector2(758,489),Vector2(741,494),Vector2(719,497),Vector2(699,508),Vector2(673,521),Vector2(646,521),Vector2(626,529),],
	[Vector2(765,471),Vector2(742,462),Vector2(714,456),Vector2(683,447),Vector2(660,433),Vector2(650,416),Vector2(646,393),Vector2(649,379),Vector2(657,368),Vector2(668,360),Vector2(673,348),Vector2(669,324),],
	[Vector2(957,502),Vector2(972,486),Vector2(984,467),Vector2(1002,447),],
	[Vector2(915,516),Vector2(902,521),Vector2(888,529),Vector2(883,543),Vector2(883,555),Vector2(879,577),Vector2(873,586),Vector2(857,598),Vector2(846,605),Vector2(837,624),Vector2(827,646),Vector2(825,659),],
	[Vector2(913,508),Vector2(892,506),Vector2(861,504),Vector2(834,497),Vector2(806,490),],
	[Vector2(944,490),Vector2(945,474),Vector2(944,448),Vector2(934,417),Vector2(919,394),Vector2(896,371),Vector2(875,356),Vector2(864,355),],
	[Vector2(961,531),Vector2(976,531),Vector2(999,531),Vector2(1011,521),Vector2(1026,509),Vector2(1041,502),Vector2(1060,506),Vector2(1075,527),Vector2(1083,536),Vector2(1095,540),Vector2(1121,540),],
	[Vector2(942,539),Vector2(961,562),Vector2(990,589),Vector2(1009,613),Vector2(1017,632),Vector2(1025,655),Vector2(1044,671),Vector2(1075,671),Vector2(1091,677),Vector2(1098,690),Vector2(1098,701),],
	[Vector2(929,536),Vector2(917,566),Vector2(906,594),Vector2(896,619),Vector2(876,640),Vector2(860,659),Vector2(848,667),],
	[Vector2(865,343),Vector2(880,329),Vector2(896,316),Vector2(913,299),Vector2(926,282),Vector2(936,272),],
	[Vector2(823,368),Vector2(811,385),Vector2(796,398),Vector2(788,424),Vector2(787,447),Vector2(784,458),],
	[Vector2(865,359),Vector2(890,366),Vector2(913,387),Vector2(926,408),Vector2(936,425),Vector2(944,455),Vector2(944,478),Vector2(942,493),],
	[Vector2(825,332),Vector2(823,309),Vector2(815,287),Vector2(807,276),Vector2(795,267),Vector2(787,259),],
	[Vector2(692,287),Vector2(704,278),Vector2(706,263),Vector2(715,244),Vector2(729,236),Vector2(745,240),],
	[Vector2(654,324),Vector2(646,337),Vector2(635,355),Vector2(608,370),Vector2(588,389),Vector2(577,412),Vector2(572,439),Vector2(576,462),Vector2(581,490),Vector2(585,517),],
	[Vector2(669,324),Vector2(672,343),Vector2(672,359),Vector2(657,368),Vector2(649,389),Vector2(649,408),Vector2(658,424),Vector2(676,443),Vector2(696,451),Vector2(718,455),Vector2(738,462),Vector2(765,471),],
	[Vector2(699,309),Vector2(718,310),Vector2(738,310),Vector2(760,309),Vector2(781,302),Vector2(800,290),Vector2(807,272),Vector2(811,256),Vector2(802,249),Vector2(783,245),],
	[Vector2(784,259),Vector2(796,270),Vector2(811,283),Vector2(819,301),Vector2(823,316),Vector2(827,328),],
	[Vector2(741,240),Vector2(733,237),Vector2(719,237),Vector2(712,255),Vector2(708,274),Vector2(695,287),],
	[Vector2(784,241),Vector2(806,233),Vector2(825,232),Vector2(844,230),Vector2(857,230),Vector2(873,240),Vector2(890,233),Vector2(906,224),Vector2(917,218),Vector2(929,222),Vector2(934,233),],
	[Vector2(787,247),Vector2(800,247),Vector2(810,256),Vector2(807,268),Vector2(796,291),Vector2(777,305),Vector2(741,309),Vector2(715,309),Vector2(696,310),],
]
