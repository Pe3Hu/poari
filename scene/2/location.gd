extends MarginContainer


#region vars
@onready var vbox = $VBox
@onready var bg = $VBox/Directions/BG
@onready var directions = $VBox/Directions
@onready var index = $VBox/Directions/Index
@onready var up = $VBox/Directions/Up
@onready var right = $VBox/Directions/Right
@onready var down = $VBox/Directions/Down
@onready var left = $VBox/Directions/Left
@onready var markers = $VBox/Markers

var isle = null
var grid = null
var border = null
var status = null
var aisles = {}
var neighbors = {}
var region = null
var tower = null
var exit = null
var karma = null
var dimensions = Vector2()
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	isle = input_.isle
	grid = input_.grid
	status = input_.status
	
	init_basic_setting()


func init_basic_setting() -> void:
	neighbors.next = null
	neighbors.prior = null
	directions.custom_minimum_size = Global.vec.size.location
	
	init_icons()
	#init_tower()
	set_frontiers()
	
	if grid.y != 0:
		vbox.move_child(directions, 0)
		karma = Global.arr.karma.front()
	else:
		karma = Global.arr.karma.back()


func init_icons() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	
	if status != "path":
		style.bg_color = Color.GRAY
	
	bg.set("theme_override_styles/panel", style)
	
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.location
	index.set_attributes(input)
	#index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.location += 1
	index.set_bg_color(Global.color.location.index)


func init_tower() -> void:
	if status == "corner":
		var input = {}
		input.isle = isle
		input.location = self
		
		var _tower = Global.scene.tower.instantiate()
		isle.towers.add_child(_tower)
		_tower.set_attributes(input)


func set_frontiers() -> void:
	for direction in Global.arr.direction:
		var frontier = get(direction)
		var input = {}
		input.location = self
		input.direction = direction
		frontier.set_attributes(input)


func add_aisle(aisle_: MarginContainer, side_: String, type_: String) -> void:
	aisles[aisle_] = side_
	var frontier = get(side_)
	frontier.set_aisle(aisle_, type_)


func recolor(color_: String) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Color(color_)


func paint(color_: Color) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = color_


func rehue(hue_: float) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Color.from_hsv(hue_, 1, 1)


func set_region(region_: MarginContainer) -> void:
	region = region_


func set_exit(team_: String) -> void:
	var input = {}
	input.type = "exit"
	input.subtype = team_

	exit = Global.scene.icon.instantiate()
	directions.add_child(exit)
	exit.set_attributes(input)
	exit.custom_minimum_size = Global.vec.size.frontier
	isle.exits[team_] = self
	
	match team_:
		"white":
			exit.set("size_flags_horizontal", SIZE_SHRINK_END)
		"black":
			exit.set("size_flags_horizontal", SIZE_SHRINK_BEGIN)


func set_entry(team_: String) -> void:
	isle.entries[team_] = self
#endregion


func add_marker(marker_: MarginContainer) -> void:
	if marker_.location != self:
		if marker_.location != null:
			marker_.location.markers.remove_child(marker_)
			marker_.location.update_size(-1)
		
		markers.add_child(marker_)
		marker_.location = self
		update_size(1)


func update_size(shift_: int) -> void:
	var flag = false
	var n = markers.get_child_count()
	
	match shift_:
		-1:
			flag = n % Global.num.location.markers == 0
		1:
			flag = n % Global.num.location.markers == 1
	
	if flag:
		dimensions = Vector2(3, n / Global.num.location.markers) * Global.vec.size.token
		isle.update_karmas(karma)
