extends "res://scene/5/token.gd"


var location = null


func start_moving(steps_: int) -> void:
	for _i in steps_:
		var destination = null
		
		match sign(steps_):
			-1:
				destination = location.neighbors.prior
			1:
				destination = location.neighbors.next
		
		destination.add_marker(self)
