extends Label
class_name Pedometer

var steps: int = 0

func _ready() -> void:
	text = "Pedometer: " + str(steps)
	Globals.pedometer = self

func step():
	steps += 1
	text = "Pedometer: " + str(steps)
