extends MarginContainer


#region vars
@onready var isles = $Isles

var sketch = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_isles()


func init_isles() -> void:
	for _i in 1:
		var input = {}
		input.continent = self
		input.dimensions = Vector2(Global.num.isle.col, Global.num.isle.row)
	
		var isle = Global.scene.isle.instantiate()
		isles.add_child(isle)
		isle.set_attributes(input)
#endregion
