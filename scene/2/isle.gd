extends MarginContainer


#region vars
@onready var locations = $HBox/Locations
@onready var aisles = $HBox/Aisles
@onready var regions = $HBox/Regions

var planet = null
var dimensions = null
var exits = {}
var entries = {}
var karmas = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	dimensions = input_.dimensions
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_locations()
	init_aisles()
	init_regions()
	
	
	for karma in Global.arr.karma:
		karmas[karma] = Vector2()


func init_locations() -> void:
	locations.columns = dimensions.x
	var corners = {}
	corners.x = [0, int(dimensions.x - 1)]
	corners.y = [0, int(dimensions.y - 1)]
	
	for _i in dimensions.y:
		for _j in dimensions.x:
			var input = {}
			input.isle = self
			input.grid = Vector2(_j, _i)
			var x = corners.x.has(int(_j))
			var y = corners.y.has(int(_i))
			
			if x or y:
				if x and y:
					input.status = "corner"
				else:
					input.status = "edge"
			else:
				input.status = "center"
			
			var location = Global.scene.location.instantiate()
			locations.add_child(location)
			location.set_attributes(input)
	
	init_exits()
	init_entries()


func init_aisles() -> void:
	var grid = Vector2.ZERO
	var n = Global.dict.neighbor.linear2.size()
	
	for _i in n + 1:
		var _j = _i  % n
		var shift = Global.dict.neighbor.linear2[_j]
		var input = {}
		input.isle = self
		var _k = (_i + n / 2) % n
		input.direction = Global.arr.direction[_k]
		input.measure = "location"
		
		while get_location(grid + shift) != null:
			input.locations = []
			var location = get_location(grid)
			input.locations.append(location)
			
			grid += shift
			location = get_location(grid)
			input.locations.append(location)
			
			var aisle = Global.scene.aisle.instantiate()
			aisles.add_child(aisle)
			aisle.set_attributes(input)
			#aisle.visible = false


func init_regions() -> void:
	var grid = Vector2.ZERO
	var location = get_location(grid)
	
	while location.grid != Vector2() or Global.num.index.region == 0:
		var input = {}
		input.isle = self
		input.locations = []
		
		for _i in Global.num.region.n:
			location = location.neighbors.next
			input.locations.append(location)
		
		var region = Global.scene.region.instantiate()
		regions.add_child(region)
		region.set_attributes(input)
		#location = location.neighbors.next
	
	for region in regions.get_children():
		region.recolor_location_based_on_index()


func init_exits() -> void:
	var teams = ["white", "black"]
	
	for team in teams:
		var index = 0
		
		if team == "white":
			index = locations.get_child_count() - 1
		
		var location = locations.get_child(index)
		location.set_exit(team)


func init_entries() -> void:
	var teams = ["white", "black"]
	
	for team in teams:
		var index = Global.num.isle.col
		
		if team == "white":
			index -= 1
		
		var location = locations.get_child(index)
		location.set_entry(team)


func check_grid(grid_: Vector2) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and dimensions.y > grid_.y and dimensions.x >  grid_.x


func get_location(grid_: Vector2) -> Variant:
	if check_grid(grid_):
		var index = grid_.y * dimensions.x + grid_.x
		return locations.get_child(index)
	
	return null
#endregion


func update_karmas(karma_: String) -> void:
	var _dimensions = Vector2()
	
	for location in locations.get_children():
		if karma_ == location.karma and location.dimensions > _dimensions:
			_dimensions = location.dimensions
	
	
	for location in locations.get_children():
		if karma_ == location.karma:
			location.markers.custom_minimum_size = _dimensions


func place_markers() -> void:
	for squad in planet.squads.get_children():
		#var team = Global.dict.mirror.team[squad.team]
		var location = entries[squad.team]
		
		for pawn in squad.pawns.get_children():
			pawn.add_marker(location)

