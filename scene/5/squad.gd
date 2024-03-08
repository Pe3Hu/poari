extends MarginContainer


#region vars
@onready var pawns = $HBox/Pawns
@onready var scripture = $HBox/Scripture

var god = null
var isle = null
var team = null
var markers = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.squad = self
	scripture.set_attributes(input)
	init_pawns(input_)


func init_pawns(input_: Dictionary) -> void:
	for pawn in input_.pawns:
		pawns.add_child(pawn)
		pawn.squad = self
		pawn.order = input_.pawns.find(pawn)
#endregion


func move_random_marker() -> void:
	var pawn = pawns.get_children().pick_random()
	var steps = isle.mileage.pool.result
	pawn.marker.start_moving(steps)
