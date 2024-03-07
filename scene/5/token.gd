extends MarginContainer


#region vars
@onready var bg = $BG
@onready var designation = $Designation
@onready var value = $Value

var proprietor = null
var type = null
var subtype = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	type = input_.type
	subtype = input_.subtype
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Vector2(Global.vec.size.token)
	var input = {}
	input.type = type
	input.subtype = subtype
	designation.set_attributes(input)
	
	input.type = "number"
	input.subtype = 0
	
	if input_.has("value"):
		input.subtype = input_.value
	
	value.set_attributes(input)
	value.custom_minimum_size = Vector2(Global.vec.size.number)
	
	if !input_.has("value"):
		value.visible = false
#endregion


#region value treatment
func get_value() -> Variant:
	return value.get_number()


func change_value(value_: Variant) -> void:
	value.change_number(value_)


func set_value(value_: Variant) -> void:
	value.set_number(value_)


func multiply_value(multiplier_: Variant) -> void:
	var _value = get_value() * multiplier_
	value.set_number(_value)
#endregion
