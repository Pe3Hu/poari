extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var continent = $HBox/Continent


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	continent.set_attributes(input)
	
	var isle = continent.isles.get_child(0)
	
	var god = cradle.pantheons.get_child(0).gods.get_child(0)
	var squad = god.prepare_squad()
	isle.add_squad(squad)
	
	isle.start_race()
