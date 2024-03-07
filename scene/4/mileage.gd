extends MarginContainer


#region vars
@onready var pool = $Pool

var isle = null
#endregion


#region vars
func set_attributes(input_: Dictionary) -> void:
	isle = input_.isle
	
	custom_minimum_size = Global.vec.size.mileage


func roll_pool() -> void:
	var dices = 2
	var faces = 6
	pool.init_dices(dices, faces)
	pool.roll_dices()
#endregion
