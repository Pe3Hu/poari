extends MarginContainer


#region var
@onready var isle = $VBox/HBox/Isle
@onready var squads = $VBox/HBox/Squads
@onready var mileage = $VBox/Mileage
@onready var moon = $VBox/Moon
@onready var timer = $Timer

var universe = null
var iteration = 0
var active = true
var host = null
var winner = null
var loser = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	init_basic_setting()


func init_basic_setting() -> void:
	Engine.time_scale = 3
	var input = {}
	input.planet = self
	input.dimensions = Vector2(Global.num.isle.col, Global.num.isle.row)
	isle.set_attributes(input)
	mileage.set_attributes(input)
	moon.set_attributes(input)
#endregion



func add_squad(squad_: MarginContainer) -> void:
	squad_.team = "white"
	
	if squads.get_child_count():
		squad_.team = "black"
	
	squad_.isle = self
	squads.add_child(squad_)


func start_race() -> void:
	isle.place_markers()
	host = squads.get_child(0)
	
	for _i in 26:
		moon.skip_all_phases()
	#moon.follow_phase()


func swap_host() -> void:
	var index = (host.get_index() + 1) % squads.get_child_count()
	host = squads.get_child(index)
