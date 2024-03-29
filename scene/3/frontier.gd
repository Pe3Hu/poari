extends MarginContainer


#region vars
@onready var bg = $BG
@onready var designation = $Designation
@onready var index = $Index
@onready var difficulty = $Difficulty

var location = null
var direction = null
var aisle = null
var traveler  = null
var underside = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	location = input_.location
	direction = input_.direction
	
	init_basic_setting()


func init_basic_setting() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	
	var keys = ["index", "difficulty", "designation"]
	
	for key in keys:
		var input = {}
		input.type = "number"
		input.subtype = 0
		
		if key == "designation":
			input.type = "direction"
			input.subtype = direction
		
		var icon = get(key)
		icon.set_attributes(input)
		icon.custom_minimum_size = Global.vec.size.frontier


func set_aisle(aisle_: MarginContainer, type_: String) -> void:
	aisle = aisle_
	type = type_
	
	index.set_number(aisle_.index.get_number())
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.frontier[type]
	visible = true
	
	if type == "entry":
		if aisle.measure == "stairwell":
			location.obstacle = aisle
	
		difficulty.set_number(aisle_.difficulty.get_number())
		designation.visible = true
		difficulty.visible = false
		index.visible = false


func set_underside(underside_: MarginContainer) -> void:
	type = "underside"
	underside = underside_
	
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.frontier[type]
	visible = true
	location.obstacle = underside
	
	#difficulty.set_number(underside_.difficulty.get_number())
	#designation.visible = true
	#difficulty.visible = true
	index.visible = false


func traveler_came(traveler_: MarginContainer) -> void:
	traveler = traveler_
	visible = true
	
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.traveler[traveler.type]
	
	difficulty.set_number(traveler_.difficulty.get_number())
	designation.visible = true
	difficulty.visible = true
	index.visible = false


func traveler_gone() -> void:
	traveler = null
	visible = false
	
	difficulty.set_number(0)
	difficulty.visible = false
#endregion
