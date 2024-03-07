extends MarginContainer


#region vars
@onready var pawns = $Pawns

var pantheon = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_pawns()


func init_pawns() -> void:
	for _i in Global.num.god.pawns:
		var input = {}
		input.god = self
	
		var pawn = Global.scene.pawn.instantiate()
		pawns.add_child(pawn)
		pawn.set_attributes(input)


func prepare_squad() -> MarginContainer:
	var options = []
	
	while pawns.get_child_count() > 0:
		var pawn = pawns.get_child(0)
		pawns.remove_child(pawn)
		options.append(pawn)
	
	#sort options
	
	var input = {}
	input.god = self
	input.pawns = []
	
	for _i in Global.num.squad.pawns:
		var pawn = options.pop_front()
		input.pawns.append(pawn)
	
	var squad = Global.scene.squad.instantiate()
	add_child(squad)
	squad.set_attributes(input)
	remove_child(squad)
	
	while !options.is_empty():
		var pawn = options.pop_front()
		pawns.append(pawn)
	
	return squad
#endregion
