extends MarginContainer


#precept vars
@onready var precepts = $Precepts

var squad = null
#endprecept


#precept init
func set_attributes(input_: Dictionary) -> void:
	squad = input_.squad
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_precepts()
	

func init_precepts() -> void:
	for sin in Global.arr.sin:
		var input = {}
		input.proprietor = self
		input.type = "sin"
		input.subtype = sin
		
		var precept = Global.scene.precept.instantiate()
		precepts.add_child(precept)
		precept.set_attributes(input)
