extends "res://scene/5/token.gd"


var location = null
var on_board = true


func start_moving(steps_: int) -> void:
	for _i in steps_:
		if on_board:
			var destination = null
			
			match sign(steps_):
				-1:
					destination = location.neighbors.prior
				1:
					destination = location.neighbors.next
			
			destination.add_marker(self)
		else:
			return


func finish() -> void:
	on_board = false
	proprietor.squad.markers.erase(self)
	location.markers.remove_child(self)
	queue_free()
