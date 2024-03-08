extends MarginContainer


#region vars
@onready var phases = $HBox/Phases
@onready var lap = $HBox/Lap
@onready var turn = $HBox/Turn

var planet = null
var phase = null
#endregion


func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_phases()


func init_phases() -> void:
	for subtype in Global.arr.phase:
		var input = {}
		input.type = "phase"
		input.subtype = subtype
		
		var icon = Global.scene.icon.instantiate()
		phases.add_child(icon)
		icon.set_attributes(input)
		icon.custom_minimum_size = Vector2(Global.vec.size.token * 2)
		icon.visible = false
	
	phase = Global.arr.phase.back()
	
	var input = {}
	input.type = "number"
	input.subtype = 1
	lap.set_attributes(input)
	lap.custom_minimum_size = Vector2(Global.vec.size.token * 2)
	
	input.subtype = -1
	turn.set_attributes(input)
	turn.custom_minimum_size = Vector2(Global.vec.size.token * 2)


#region phase
func skip_all_phases() -> void:
	for _i in Global.num.phase.n:
		follow_phase()


func follow_phase() -> void:
	if planet.loser == null:
		var index = Global.arr.phase.find(phase)
		var icon = phases.get_child(index)
		icon.visible = false
		var shift = 1
		index = (index + shift) % Global.arr.phase.size()
		
		phase = Global.arr.phase[index]
		icon = phases.get_child(index)
		icon.visible = true
		
		if index == 0:
			planet.swap_host()
		
		turn.change_number(1)
		
		if turn.get_number() == Global.num.turn.n:
			lap.change_number(1)
			turn.set_number(0)
		
		var func_name = phase + "_" + "phase"
		call(func_name)


func rolling_phase() -> void:
	planet.mileage.roll_pool()


func searching_phase() -> void:
	pass


func selecting_phase() -> void:
	pass


func moving_phase() -> void:
	planet.host.move_random_marker()


func ending_phase() -> void:
	planet.mileage.pool.reset()
	
	if planet.host.markers.is_empty():
		planet.loser = false
	else:
		follow_phase()


#endregion
