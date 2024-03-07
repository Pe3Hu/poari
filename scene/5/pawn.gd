extends MarginContainer


#region vars
@onready var bg = $BG
@onready var index = $Index

var god = null
var squad = null
var order = null
var marker = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.pawn
	
	init_icons()


func init_icons() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.pawn
	index.set_attributes(input)
	Global.num.index.pawn += 1


func add_marker(location_: MarginContainer) -> void:
	var input = {}
	input.proprietor = self
	input.type = "team"
	input.subtype = squad.team
	input.value = order
	
	marker = Global.scene.marker.instantiate()
	add_child(marker)
	marker.set_attributes(input)
	remove_child(marker)
	location_.add_marker(marker)
#endregion
