extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.direction = ["up", "right", "down", "left"]
	arr.tower = ["harmony", "life", "death", "souls"]
	arr.karma = ["inferno", "paradise"]


func init_num() -> void:
	num.index = {}
	num.index.location = 0
	num.index.aisle = 0
	num.index.underside = 0
	num.index.tower = 0
	num.index.region = 0
	num.index.pawn = 0
	
	num.region = {}
	num.region.n = 6
	num.region.m = 4
	
	num.isle = {}
	num.isle.col = num.region.n * 2
	num.isle.row = 2
	num.isle.hex = 6
	
	num.god = {}
	num.god.pawns = 7
	
	num.squad = {}
	num.squad.pawns = 7
	
	num.team = {}
	num.team.n = 2
	
	num.location = {}
	num.location.markers = 3


func init_dict() -> void:
	init_neighbor()
	init_labyrinth()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_labyrinth() -> void:
	dict.aisle = {}
	dict.aisle.side = {}
	dict.aisle.side["right"] = {}
	dict.aisle.side["right"]["entry"] = "right"
	dict.aisle.side["right"]["exit"] = "left"
	dict.aisle.side["left"] = {}
	dict.aisle.side["left"]["entry"] = "left"
	dict.aisle.side["left"]["exit"] = "right"
	dict.aisle.side["up"] = {}
	dict.aisle.side["up"]["entry"] = "up"
	dict.aisle.side["up"]["exit"] = "down"
	dict.aisle.side["down"] = {}
	dict.aisle.side["down"]["entry"] = "down"
	dict.aisle.side["down"]["exit"] = "up"
	
	dict.aisle.pair = {}
	dict.aisle.pair["entry"] = "exit"
	dict.aisle.pair["exit"] = "entry"
	
	dict.obstacle = {}
	dict.obstacle.direction = {}
	dict.obstacle.direction["sage"] = "down"
	dict.obstacle.direction["frontier"] = "down"
	dict.obstacle.direction["guardian"] = "up"
	dict.obstacle.direction["trap"] = "up"
	
	dict.traveler = {}
	dict.traveler.frontier = {}
	dict.traveler.frontier["guardian"] = "up"
	dict.traveler.frontier["sage"] = "down"
	dict.traveler.frontier["trap"] = "up"
	dict.traveler.frontier["frontier"] = "down"
	
	dict.obstacle.role = {}
	dict.obstacle.role["sage"] = "defender"
	dict.obstacle.role["frontier"] = "defender"
	dict.obstacle.role["underside"] = "defender"
	dict.obstacle.role["guardian"] = "aggressor"
	dict.obstacle.role["trap"] = "aggressor"
	
	dict.underside = {}
	dict.underside.linear = {}
	dict.underside.linear[Vector2( 0,-1)] = "down"
	dict.underside.linear[Vector2( 1, 0)] = "left"
	dict.underside.linear[Vector2( 0, 1)] = "up"
	dict.underside.linear[Vector2(-1, 0)] = "right"
	
	dict.mirror = {}
	dict.mirror.team = {}
	dict.mirror.team["white"] = "black"
	dict.mirror.team["black"] = "white"


func init_blank() -> void:
	dict.blank = {}
	dict.blank.rank = {}
	var exceptions = ["rank"]
	
	var path = "res://asset/json/maoiri_blank.json"
	var array = load_data(path)
	
	for blank in array:
		blank.rank = int(blank.rank)
		var data = {}
		
		for key in blank:
			if !exceptions.has(key):
				data[key] = blank[key]
			
		if !dict.blank.rank.has(blank.rank):
			dict.blank.rank[blank.rank] = []
	
		dict.blank.rank[blank.rank].append(data)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.icon = load("res://scene/0/icon.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.isle = load("res://scene/2/isle.tscn")
	scene.location = load("res://scene/2/location.tscn")
	
	scene.aisle = load("res://scene/3/aisle.tscn")
	scene.region = load("res://scene/3/region.tscn")
	
	scene.dice = load("res://scene/4/dice.tscn")
	scene.facet = load("res://scene/4/facet.tscn")
	
	scene.pawn = load("res://scene/5/pawn.tscn")
	scene.squad = load("res://scene/5/squad.tscn")
	scene.token = load("res://scene/5/token.tscn")
	scene.marker = load("res://scene/5/marker.tscn")
	


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(vec.size.sixteen)
	vec.size.facet = Vector2(64, 64) * 0.5
	vec.size.location = Vector2(64, 64)
	vec.size.frontier = Vector2(18, 18) * 1.25
	vec.size.pawn = Vector2(vec.size.location)
	vec.size.token = Vector2(vec.size.location / 3)
	
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.aisle = {}
	color.aisle.location = Color.from_hsv(60 / h, 0.6, 0.7)

	color.location = {}
	color.location.index = Color.from_hsv(60 / h, 0.0, 0.7)
	
	color.frontier = {}
	color.frontier.entry = Color.from_hsv(60 / h, 0.6, 0.7)
	color.frontier.exit = Color.from_hsv(30 / h, 0.6, 0.7)
	color.frontier.underside = Color.from_hsv(90 / h, 0.6, 0.7)
	
	color.route = {}
	color.route.active = Color.from_hsv(330 / h, 0.6, 0.7)
	color.route.passive = Color.from_hsv(30 / h, 0.6, 0.7)
	
	color.traveler = {}
	color.traveler.guardian = Color.from_hsv(0 / h, 0.6, 0.7)
	color.traveler.sage = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.difficulty = Color.from_hsv(150 / h, 0.6, 0.7)
	
	color.scenery = {}
	color.scenery["forest of life"] = Color.from_hsv(120 / h, 0.6, 0.7)
	color.scenery["field of death"] = Color.from_hsv(270 / h, 0.6, 0.7)
	color.scenery["sea of souls"] = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.tower = {}
	color.tower["life"] = Color.from_hsv(0 / h, 0.6, 0.7)
	color.tower["death"] = Color.from_hsv(120 / h, 0.6, 0.7)
	color.tower["souls"] = Color.from_hsv(60 / h, 0.6, 0.7)
	color.tower["harmony"] = Color.from_hsv(270 / h, 0.6, 0.7)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
